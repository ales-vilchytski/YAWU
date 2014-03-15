$(document).ready(function() {
    var $form = $('[data-upload="form"]');
    var type = $form.data('type');
    var action = $form.data('action');
    var $progressBar = $('.progress-bar', $form);
    var $status = $('[data-upload="status"]', $form);
    var $files = $('.files', $status);
    
    $form.fileupload({
        dataType: 'json',
        dropZone: $form,
        url: action,
        start: function (e) {
            $progressBar.css('width', '0%');
            $status.collapse('show');
        },
        done: function (e, data) {
            $files.append(tmpl('template-uploaded', data.result));
            
            var $list = $('[data-upload="list"][data-type="' + type + '"]');
                
            data.result.files.forEach(function(file) {
                if (!file.error) {
                    $list.append(
                        $('<option/>')
                            .val(file.id)
                            .text(file.name)
                    );
                }
            });
        },
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $progressBar.css('width', progress + '%');
        },
        stop: function (e) {
            $progressBar.css('width', '0%');
        }
    });
        
    $('[data-upload="clean-status"]', $form).on('click', function(e) {
        $status.collapse('hide');
        $files.empty();
        $progressBar.css('width', '0%');
    })
});
