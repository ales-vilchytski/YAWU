$(document).ready(function() {
   var input_editor = editors.widget('input_xml');
   var output_editor = editors.widget('output_xml');
      
   /*
    * AJAX handling
    */
   var errorPanel = panels.widget('error_panel_xml');
   
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