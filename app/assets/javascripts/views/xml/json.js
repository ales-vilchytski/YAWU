$(document).ready(function() {
   var outputEditor = concerns.editorOutput('output_json');
   var errorPanel = YAWU.errorPanel;
   var debug = YAWU.debug;

   /*
    * AJAX handling
    */
   $('#form')
       .on('ajax:beforeSend', function(e, xhr, settings) {
           debug.debugAjaxBeforeSend(e, xhr, settings);
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
           debug.debugAjaxComplete(e, xhr, status);
       });
});
