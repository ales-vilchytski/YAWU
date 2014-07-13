$(document).ready(function() {
   var input_editor = concerns.editor('input_xml');
   var output_editor = concerns.editor('output_xml');

   console.log(input_editor instanceof concerns.Base)
   
   /*
    * AJAX handling
    */
   var errorPanel = concerns.panel('error_panel_xml');
   
   $('#form')
       .on('ajax:beforeSend', function(e, xhr, settings) {
           YAWU.debug.debugAjaxBeforeSend(e, xhr, settings);
       })
       .on('ajax:success', function(e, data, status, xhr) {
           if (data.error) {
               errorPanel.show(data.error.message, data.error.description);
           } else {
               output_editor.setValue(data['result']);
           }
       })
       .on('ajax:error', function(e, xhr, status, error) {
           errorPanel.show(String(xhr.status), error);
       })
       .on('ajax:complete', function(e, xhr, status) {
           YAWU.debug.debugAjaxComplete(e, xhr, status);
       });
});