namespace('YAWU.views.common', function() {
    concerns = include('concerns');
    
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
                errorPanel.show(data.error.message, data.error.description);
            } else {
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