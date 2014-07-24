$(document).ready(function() {
   var uploadForm = concerns.uploadForm('input_xsd_files_upload');
   var uploadList = concerns.uploadList('input_xsd_files_list');
   uploadForm.addUploadList(uploadList);
   
   YAWU.views.common.bindAjaxToForm({
       formId: 'form',
       outputEditorId: 'output_editor',
       serverResultElement: 'result'
   });
});
