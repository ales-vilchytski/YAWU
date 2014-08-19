/**
 * Binds Ace editors to AJAX requests and responses according to data-attributes:
 *   [data-editor='/Type/'] - editor component. Available types:
 *      input - input source, i.e. element for Ace editor holding named input argument
 *      output - output source, i.e. element for Ace editor holding named result 
 *      form - element with inputs (Ace editors or plain html-fields) and outputs (Ace editors)
 *             it should be an html-form with data-remote='true'
 *      error-heading - pane heading for error message
 *      error-body - pane body for error description from 'error' field retrieved from server.
 *                   'error' from server should be object with 'message' and 
 *                   'description' fields
 *   [data-editor-settings='{JSON}'] - parameters of editor or form:
 *      name : for editor - name of input or output parameter
 *      mode : for editor - mode of editor (default is ace/mode/javascript)
 *      theme : for editor - theme of ace editor (default is ace/theme/eclipse)
 *
 * All outputs (editors) should have name (data-editor-settings['name']) according 
 * to results object retrieved from server.
 * Any submission of remote form in [data-editor='form'] element triggers copy
 * values of Ace input editors ([data-editor='input']) to this form in hidden 
 * textareas named as data-editor-settings['name'] value.
 * Combination 'Ctrl+Enter' on the [data-editor='form'] submits form.
 */
$(document).ready(function() {

    function createAceEditor(element, form, result) {
        var settings = $(element).data('editorSettings');
        var name = settings['name'];
        var mode = settings['mode'] || 'ace/mode/javascript';
        var theme = settings['theme'] || 'ace/theme/eclipse';
        
        var editor = ace.edit(element);
        editor.getSession().setMode(mode);
        editor.setTheme(theme);
        
        // named form field for submitting value of Ace via form
        if ($(element).data('editor') == 'input') {
            var $textarea = $('<textarea>', {
                name : name,
                hidden : true
            });
            $(element).append($textarea);
            
            $(form).on('submit', function() {
                $textarea.val(editor.getValue());
            });
        }
        
        if (result) {
            result[name] = editor;
        }
        return result;
    }
    
    /*
     * Create inputs and outputs and bind AJAX handling
     */
    $('form[data-editor="form"]').each(function(i, form) {
        var formSettings = $(form).data('editorSettings') || {};
        var formName = formSettings['name'];
        //TODO add propagation of settings like mode and theme for editors
        //var theme = formSettings['theme']; ...
        
        $('[data-editor="input"]', form).each(function(i, input) {
           createAceEditor(input, form);
        });
        
        var outputEditors = {};
        $('[data-editor="output"]', form).each(function(i, output) {
            createAceEditor(output, form, outputEditors);
        });
        
        /*
         * AJAX handling
         */
        var errorPanel = concerns.panelError('error_panel');
       
        function showError(header, body) {
            errorPanel.show(header, body);
        }
        
        $(form)
        .on('ajax:beforeSend', function(e, xhr, settings) {
            YAWU.debug.debugAjaxBeforeSend(e, xhr, settings);
        })
        .on('ajax:success', function(e, data, status, xhr) {
            if (data.error) {
                showError(data.error.message, data.error.description);
            } else {
                for (var i in data) {
                    outputEditors[i].setValue(data[i]);
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
        (function mapCtrlEnter() {
            var keyState = {};
            $(form).on('keydown', keyState, function(e) {
                if (e.which == 17) {
                    e.data.ctrl = 'pressed';
                }
            });
            
            $(form).on('keyup', keyState, function(e) {
                if (e.which == 17) {
                    e.data.ctrl = null;
                } else if (e.which == 13 && e.data.ctrl == 'pressed') {
                    $(form).trigger('submit');
                }
            });
        })();
    });
});


/**
 * Adds ability to enter tabs for inputs with [data-input="tab-allowed"].
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

/**
 * Adds functionality of 'return up' and 'go down' for buttons with data attrs:
 *   [data-show="up"]
 *   [data-show="down"]
 */
$(document).ready(function() {
    var $up = $('body');
    var $down = $('body *').filter(':last');
    
    $('[data-show="up"]').on('click', function() {
        scrollTo($up);
    });
    
    $('[data-show="down"]').on('click', function() {
        scrollTo($down);
    });

});
