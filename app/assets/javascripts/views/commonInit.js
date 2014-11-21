$(document).ready(function() {
    include('concerns.creator').createWidgets();
});

/**
 * Error panel in top of page for printing errors
 */
$(document).ready(function() {
    include('concerns.panelError');
    
    window.namespace('YAWU.errorPanel');
    YAWU.errorPanel = include('concerns').panelError('error_panel');
});

/**
 * Debug panel in bottom of page for printing some useful info
 */
$(document).ready(function() {
    var concerns = include('concerns');
    include('concerns.editorOutput');
    
    var debugEditor = concerns.editorOutput('debug_output_editor');
    var $clearButton = $('#debug_output_clear_button');
    
    debugEditor.getAce().getSession().setUseWrapMode(true);
    
    $clearButton.button();
    $clearButton.on('click', function() {
       debugEditor.setValue(''); 
    });
    
    //===== Common "debug panel" functions ======//
    window.namespace('YAWU.debug');
    
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
