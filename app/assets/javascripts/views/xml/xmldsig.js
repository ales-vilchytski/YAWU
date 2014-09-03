/**
 * Created by SBT-Kozich-MA on 06.03.14.
 */
$(document).ready(function() {
    $("input[data-master='true']").change(function () {
        var master_name = $(this).attr('name');
        var master_value = $(this).val();
        var slaves = $("[data-master-name='" + master_name + "']", $(this).closest('form')).hide();
        var show_slaves = $(slaves).filter("[data-master-values~='" + master_value + "']").show();
        $(slaves).hide();
        $(show_slaves).show();
    });
    
    YAWU.views.common.bindAjaxToForm({
        formId: 'form',
        outputEditorId: 'output_xml_editor',
        serverResultElement: 'result'
    });
});