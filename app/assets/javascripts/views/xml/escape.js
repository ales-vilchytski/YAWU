$(document).ready(function() {
   var inputEditor = concerns.editorInput('input_xml');
   var outputEditor = concerns.editorOutput('output_text');
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
