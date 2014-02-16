var global = this;

$(document).ready(function() {
    var $debugEditor = $('#debug_editor');
    
    var debugEditor = ace.edit($debugEditor[0]);
    debugEditor.getSession().setUseWrapMode(true);
    
    $("#debug_toggle").change(function() {
        if(this.checked) {
            $debugEditor.removeClass('hide');
        } else {
            $debugEditor.addClass('hide');
        }
    });
    
    global.namespace('yawu.debug');
    
    yawu.debug.clearDebugPanel = function() {
        debugEditor.setValue('');
    };
    
    yawu.debug.debugAjaxComplete = function(e, xhr, status) {
        debugEditor.setValue(debugEditor.getValue() + "\nStatus: "  + JSON.stringify(status) 
                + "\nXHR: " + JSON.stringify(xhr));
    };
    
    yawu.debug.debugAjaxSuccess = function(e, data, status, xhr) {
        debugEditor.setValue(debugEditor.getValue() + "\nSUCCESS\nStatus: "
                + JSON.stringify(status) + "\nXHR: "
                + JSON.stringify(xhr) + '\ndata: '
                + JSON.stringify(data));
    };

    yawu.debug.debugAjaxError = function(e, xhr, status, error) {
        debugEditor.setValue(debugEditor.getValue() + "\nERROR\nStatus: "
                + JSON.stringify(status) + "\nXHR: "
                + JSON.stringify(xhr) + '\nerr: '
                + JSON.stringify(error));
    };
    
    yawu.debug.debugAjaxBeforeSend = function(e, xhr, settings) {
        debugEditor.setValue(debugEditor.getValue() + "\nRequest\nXHR: "
                + JSON.stringify(xhr) + '\nSettings: '
                + JSON.stringify(settings));
    };
});


