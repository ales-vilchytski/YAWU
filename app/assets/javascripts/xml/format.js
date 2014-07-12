$(document).ready(function() {
   var input_editor = editors.widget('input_xml');
   var output_editor = editors.widget('output_xml');
   
   [input_editor, output_editor].forEach(function(editor) {
       editor.setReadOnly(false);
       editor.setMode('xml');
       editor.setTheme('eclipse');
   })
   
   $('#form')
       .on('ajax:beforeSend', function(e, xhr, settings) {
           YAWU.debug.debugAjaxBeforeSend(e, xhr, settings);
       })
       .on('ajax:success', function(e, data, status, xhr) {
           if (data.error) {
               alert(data.error.message + "\n" + data.error.description);
           } else {
               output_editor.setValue(data['result']);
           }
       })
       .on('ajax:error', function(e, xhr, status, error) {
           alert(String(xhr.status) + ' ' + error);
       })
       .on('ajax:complete', function(e, xhr, status) {
           YAWU.debug.debugAjaxComplete(e, xhr, status);
       });
});