/**
 * Debug panel in bottom of page for printing some useful info
 * 
 * TODO move to concerns (something like "panelAjaxDebug")
 */
source('editor/debugPanel', ['concerns/concerns', 'concerns/editorOutput'], function() {
    
    var debugEditor = concerns.editorOutput('debug_output_editor');
    var $clearButton = $('#debug_output_clear_button');
    
    debugEditor.getAce().getSession().setUseWrapMode(true);
    
    $clearButton.button();
    $clearButton.on('click', function() {
       debugEditor.setValue(''); 
    });
    
    /**
     *  Common "debug panel" functions:
     */
    namespace('YAWU.debug', function() {
        this.clearDebugPanel = function() {
            debugEditor.setValue('');
        };
        
        this.debugAjaxComplete = function(e, xhr, status) {
            debugEditor.setValue(debugEditor.getValue() + "\nStatus: "  + JSON.stringify(status) 
                    + "\nXHR: " + JSON.stringify(xhr));
        };
        
        this.debugAjaxSuccess = function(e, data, status, xhr) {
            debugEditor.setValue(debugEditor.getValue() + "\nSUCCESS\nStatus: "
                    + JSON.stringify(status) + "\nXHR: "
                    + JSON.stringify(xhr) + '\ndata: '
                    + JSON.stringify(data));
        };

        this.debugAjaxError = function(e, xhr, status, error) {
            debugEditor.setValue(debugEditor.getValue() + "\nERROR\nStatus: "
                    + JSON.stringify(status) + "\nXHR: "
                    + JSON.stringify(xhr) + '\nerr: '
                    + JSON.stringify(error));
        };
        
        this.debugAjaxBeforeSend = function(e, xhr, settings) {
            debugEditor.setValue(debugEditor.getValue() + "\nRequest\nXHR: "
                    + JSON.stringify(xhr) + '\nSettings: '
                    + JSON.stringify(settings));
        };
    });
    
});