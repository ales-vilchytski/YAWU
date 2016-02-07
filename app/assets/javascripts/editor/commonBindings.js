source('editor/commonBindings', ['concerns/concerns', 'editor/debugPanel'], function() {
    namespace('YAWU.views.common', function() {
        
        this.bindAjaxToForm = function(opts) {
            var formId = opts['formId'];
            var outputEditorId = opts['outputEditorId'];
            var serverResultElement = opts['serverResultElement'];
            
            var outputEditor = concerns.editorOutput(outputEditorId);
            var errorPanel = YAWU.errorPanel;
            var debug = YAWU.debug;
            
            /*
            * AJAX handling
            */
            $('#' + formId)
            .on('ajax:beforeSend', function(e, xhr, settings) {
                debug.debugAjaxBeforeSend(e, xhr, settings);
            })
            .on('ajax:success', function(e, data, status, xhr) {
                if (data.error) {
                    var timestamp = new Date();
                    errorPanel.show(
                        data.error.message + ' (' + timestamp.getHours() + ':' + timestamp.getMinutes() + ':' + timestamp.getSeconds() + ')',
                        data.error.description);
                } else {
                    errorPanel.hide();
                    outputEditor.setValue(data[serverResultElement]);
                }
            })
            .on('ajax:error', function(e, xhr, status, error) {
                errorPanel.show(String(xhr.status), error);
            })
            .on('ajax:complete', function(e, xhr, status) {
                debug.debugAjaxComplete(e, xhr, status);
            });
        };
    });
});