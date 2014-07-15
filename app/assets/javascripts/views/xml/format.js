$(document).ready(function() {
   var inputEditor = concerns.editorInput('input_xml');
   var outputEditor = concerns.editorOutput('output_xml');
   var errorPanel = concerns.panelError('error_panel_xml');

   /*
    * AJAX handling
    */
   $('#form')
       .on('ajax:beforeSend', function(e, xhr, settings) {
           YAWU.debug.debugAjaxBeforeSend(e, xhr, settings);
       })
       .on('ajax:success', function(e, data, status, xhr) {
           if (data.error) {
               errorPanel.show(data.error.message, data.error.description);
           } else {
               outputEditor.setValue(data['result']);
           }
       })
       .on('ajax:error', function(e, xhr, status, error) {
           errorPanel.show(String(xhr.status), error);
       })
       .on('ajax:complete', function(e, xhr, status) {
           YAWU.debug.debugAjaxComplete(e, xhr, status);
       });
});