/**
 * Binds Ace editors to AJAX requests and responses according to data-attributes:
 *   [data-editor='input|output|form|submit'] - input source, output destination 
 *                                              form with editors or AJAX 
 *                                              submitting form accordingly
 *   [data-editor-settings='{JSON}'] - parameters of editor or form:
 *      name : for editor or form - name of input or output parameter 
 *                                  in AJAX requests
 *      mode : for editor - mode of editor (default is ace/mode/javascript)
 *      theme : for editor - theme of ace editor (default is ace/theme/eclipse)
 *
 * All inputs (editors or input fields) should be wrapped by 
 * [data-editor='form'] tag.
 * Forms setting 'name' means "namespace" of all parameters (or no namespace 
 * if setting is omitted). Only 1 level nesting is supported.
 * All outputs (editors) should have name settings according to results 
 * receiving from server.
 * Any submission of [data-editor='submit'] form grabs all inputs, compose them 
 * as JSON tree and passes this tree to server with AJAX. Results are mapped to
 * outputs.
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
            for (var i in data) {
                outputs[i].setValue(data[i]);
            }
         })
        .on('ajax:error', function(e, xhr, status, error) {
            //TODO - create error pane for err. messages
            for (var i in outputs) {
                outputs[i].setValue("ERROR: " + error);
            }
        })
        .on('ajax:complete', function(e, xhr, status) {
            YAWU.debug.debugAjaxComplete(e, xhr, status);
        });
      
});

