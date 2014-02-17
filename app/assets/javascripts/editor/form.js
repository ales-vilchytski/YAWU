/**
 * Binds Ace editors to form according to data-attributes:
 *   [data-editor='input|output|form'] - input source, output source or form with editors accordingly
 *   [data-editor-settings='{JSON}'] - parameters of editor or form:
 *      name : for editor - name of input or output parameter in AJAX requests
 *      mode : for editor - mode of editor (default is ace/mode/javascript)
 *      theme : for editor - theme of ace editor (default is ace/theme/eclipse)
 */
$(document).ready(function() {

    var $forms = $('[data-editor="form"]');
    $forms.each(function(i, form) {        
        var $inputs = $('[data-editor="input"]', form);
        var $outputs = $('[data-editor="output"]', form);
        
        var inputs = {}, outputs = {};
        
        function createAceEditor(element, holder) {
            var settings = $(element).data('editorSettings');
            var name = settings['name'];
            var mode = settings['mode'] || 'ace/mode/javascript';
            var theme = settings['theme'] || 'ace/theme/eclipse';
            
            var editor = ace.edit(element);
            editor.getSession().setMode(mode);
            editor.setTheme(theme);
            
            holder[name] = editor;
        }
        
        $inputs.each(function(i, input) {
            createAceEditor(input, inputs);
        });
        
        $outputs.each(function(i, output) {
            createAceEditor(output, outputs);
        });
        
        $(form)
            .on('ajax:beforeSend', function(e, xhr, settings) {
                var request = {};
                for (var i in inputs) {
                    request[i] = inputs[i].getValue();
                }
                            
                settings.data = JSON.stringify(request);
                settings.dataType = 'json';
                
                xhr.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
                
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
      
    
});
