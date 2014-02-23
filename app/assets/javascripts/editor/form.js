/**
 * Binds Ace editors to AJAX requests and responses according to data-attributes:
 *   [data-editor='/Type/'] - editor component. Available types:
 *      input - input source, i.e. element for Ace editor holding named input argument
 *      output - output source, i.e. element for Ace editor holding named result 
 *      form - form with inputs (Ace editors or plain html-fields) which combine 
 *             them into namespace
 *      submit - form with 'data-remote: true' for submitting inputs via AJAX
 *      error-heading - pane heading for error message (standard XHR error object)
 *      error-body - pane body for error description from 'error' field 
 *                   retrieved from server
 *                   'error' from server should be object with 'message' and 
 *                   'description' fields
 *   [data-editor-settings='{JSON}'] - parameters of editor or form:
 *      name : for editor or form - name of input or output parameter 
 *                                  in AJAX requests
 *      mode : for editor - mode of editor (default is ace/mode/javascript)
 *      theme : for editor - theme of ace editor (default is ace/theme/eclipse)
 *   [data-editor-anchor] - anchor which marks section with results. This anchor
 *                          is focused after successful AJAX request 
 *
 * All inputs (editors or input fields) should be wrapped by [data-editor='form'] tag.
 * Forms setting 'name' means "namespace" of all parameters (or no namespace 
 * if setting is omitted). Only 1 level nesting is supported.
 * All outputs (editors) should have name settings according to results 
 * receiving from server.
 * Any submission of [data-editor='submit'] form grabs all inputs, compose them 
 * as JSON tree and passes this tree to server using AJAX. Results are mapped to
 * outputs. 
 * After successful request anchor with 'data-editor-anchor' attribute is focused.
 * Combination 'Ctrl+Enter' on the [data-editor='form'] submits form.
 */
$(document).ready(function() {

    var inputs = {};
    var outputs = {};
    
    function createAceEditor(input, holder) {
        var settings = $(input).data('editorSettings');
        var name = settings['name'];
        var mode = settings['mode'] || 'ace/mode/javascript';
        var theme = settings['theme'] || 'ace/theme/eclipse';
        
        var editor = ace.edit(input);
        editor.getSession().setMode(mode);
        editor.setTheme(theme);
        
        holder[name] = editor;
    }
    
    /*
     * Create inputs and outputs holders. Every holder responds to 'getValue()' method
     */
    $('[data-editor="form"]').each(function(i, form) {
        var formSettings = $(form).data('editorSettings') || {};
        var formName = formSettings['name'];
        //TODO add propagation of settings like mode and theme for editors
        //var theme = formSettings['theme']; ...
                
        $('[data-editor="input"]', form).each(function(i, input) {
           createAceEditor(input, formName ? namespace.call(inputs, formName) : inputs);
        });
        
        $(':input', form).each(function(i, input) {
            var name = $(input).attr('name');
            if (name) {
                //create object responding to method getValue() using closure
                var holder = function(inputElement) {
                    return { 
                        getValue: function() { return $(inputElement).val(); }
                    };
                }(input);
                
                var inp = (formName ? namespace.call(inputs, formName) : inputs);
                inp[name] = holder;
            }
        });
    });
       
    $('[data-editor="output"]').each(function(i, output) {
        createAceEditor(output, outputs);
    });

 
    /*
     * AJAX handling
     */
    var $errHead = $('[data-editor="error-heading"]');
    var $errBody = $('[data-editor="error-body"]');
    var $resultAnchor = $('[data-editor-anchor]');
   
    function showError(header, body) {
        $errHead.text(header);
        $errBody.text(body || $errBody.data('defaultError'));
        
        var collapseTarget = $errHead.data('target') || $errBody.data('target');
        $(collapseTarget).collapse('show');
    }
    
    $('[data-editor="submit"]')
        .on('ajax:beforeSend', function(e, xhr, settings) {
            var request = {};
            //TODO implement more smartly
            // map all values returned by .getValue() to request object
            for (var i in inputs) {
                if (inputs[i].getValue != null) {
                    request[i] = inputs[i].getValue();
                } else {
                    for (var j in inputs[i]) {
                        namespace.call(request, i)[j] = inputs[i][j].getValue();
                    }
                }
            }
            
            settings.data = JSON.stringify(request);
            xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
            
            settings.dataType = 'json';
            xhr.setRequestHeader("Accept", "application/json, text/javascript, */*; q=0.01");
            
            YAWU.debug.debugAjaxBeforeSend(e, xhr, settings);
        })
        .on('ajax:success', function(e, data, status, xhr) {
            if (data.error) {
                showError(data.error.message, data.error.description);
            } else {
                for (var i in data) {
                    var j = i;
                    outputs[i].setValue(data[i]);
                }
                
                /*
                 * Focus on anchor with results of request
                 */
                var resultAnchor = $resultAnchor.attr('name');
                if (resultAnchor) {
                    resultAnchor = '#' + resultAnchor;
                    // add if none or replace if present anchor to current URL
                    var anchorRegex = new RegExp('(#*' + resultAnchor + '$)|($)');
                    var newLoc = new String(window.location).replace(anchorRegex, resultAnchor);
                    window.location = newLoc;
                }
            }
         })
        .on('ajax:error', function(e, xhr, status, error) {
            showError(String(xhr.status) + ' ' + error);
        })
        .on('ajax:complete', function(e, xhr, status) {
            YAWU.debug.debugAjaxComplete(e, xhr, status);
        });
    
    /*
     * Map shortcut 'Ctrl+Enter' for submitting form with ['data-editor="submit"]
     */
    var keyState = {};
    $('[data-editor="form"]').on('keydown', keyState, function(e) {
        if (e.which == 17) {
            e.data.ctrl = 'pressed';
        }
    });
    
    $('[data-editor="form"]').on('keyup', keyState, function(e) {
        if (e.which == 17) {
            e.data.ctrl = null;
        } else if (e.which == 13 && e.data.ctrl == 'pressed') {
            $('[data-editor="submit"]').trigger('submit');
        }
    });
});


/*
 * Adds for inputs with [data-input="tab-allowed"] ability to enter tabs.
 * Works with selections
 */
$(document).ready(function() {
    $('[data-input="tab-allowed"]').on('keydown', function(e) {
        if(e.which == 9 && e.target == this) {
            var input = $(this);
            var start = this.selectionStart,  end = this.selectionEnd;
            var current = input.val();
            
            var result = current.slice(0, start) + '\t' + current.slice(end);
            input.val(result);
            
            this.selectionStart = start + 1;
            this.selectionEnd = start + 1;
            
            e.preventDefault();
        }
    });

});
