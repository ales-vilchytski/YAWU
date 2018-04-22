$(document).ready(function() {
    YAWU.views.common.bindAjaxToForm({
        formId: 'form',
        outputEditorId: 'output',
        serverResultElement: 'result'
    });

    $('#form').submit();
});
