$(document).ready(function() {
    YAWU.views.common.bindAjaxToForm({
        formId: 'form',
        outputEditorId: 'output',
        serverResultElement: 'result'
    });

    var uploadForm = concerns.uploadForm('input_url_coding_files_upload');
    var uploadList = concerns.uploadList('input_url_coding_files_list');
    uploadForm.addUploadList(uploadList);

});
