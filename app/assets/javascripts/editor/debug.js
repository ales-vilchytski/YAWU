var global = this;

$(document).ready(function() {
    var $debugEditor = $('#debug_editor');
    
    var debugEditor = ace.edit($debugEditor[0]);
    debugEditor.getSession().setUseWrapMode(true);
    
    global.namespace('YAWU.debug');
    
    YAWU.debug.clearDebugPanel = function() {
        debugEditor.setValue('');
    };
    
    YAWU.debug.debugAjaxComplete = function(e, xhr, status) {
        debugEditor.setValue(debugEditor.getValue() + "\nStatus: "  + JSON.stringify(status) 
                + "\nXHR: " + JSON.stringify(xhr));
    };
    
    YAWU.debug.debugAjaxSuccess = function(e, data, status, xhr) {
        debugEditor.setValue(debugEditor.getValue() + "\nSUCCESS\nStatus: "
                + JSON.stringify(status) + "\nXHR: "
                + JSON.stringify(xhr) + '\ndata: '
                + JSON.stringify(data));
    };

    YAWU.debug.debugAjaxError = function(e, xhr, status, error) {
        debugEditor.setValue(debugEditor.getValue() + "\nERROR\nStatus: "
                + JSON.stringify(status) + "\nXHR: "
                + JSON.stringify(xhr) + '\nerr: '
                + JSON.stringify(error));
    };
    
    YAWU.debug.debugAjaxBeforeSend = function(e, xhr, settings) {
        debugEditor.setValue(debugEditor.getValue() + "\nRequest\nXHR: "
                + JSON.stringify(xhr) + '\nSettings: '
                + JSON.stringify(settings));
    };
});


