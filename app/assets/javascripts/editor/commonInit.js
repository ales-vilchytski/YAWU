$(document).ready(function() {
    include('concerns/concerns');
    include('concerns/panelError');
    include('editor/commonBindings');
    
    concerns.createWidgets();
    
    /**
     * Error panel in top of page for printing errors
     */
    namespace('YAWU.errorPanel');
    YAWU.errorPanel = concerns.panelError('error_panel');
});
