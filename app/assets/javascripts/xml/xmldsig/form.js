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

//    $("input[name='file_upload']").fileupload({
    $('#file_upload').fileupload({
        url: 'file_upload',
//        multiple: true,
        dataType: 'json',
        autoUpload: false,
        done: function (e, data) {
            $.each(data.result.files, function (index, file) {
                $('<p/>').text(file.name).appendTo('#files');
                $('.provider_input').find('select').append('<option value="' + file.name + '">' + file.name + '</option>')
            });
        },
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $('#progress .progress-bar').css('width', progress + '%');
        }
    });
});