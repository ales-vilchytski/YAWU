/**
 * Binds file upload form built on top of jQuery FileUpload.
 * https://github.com/blueimp/jQuery-File-Upload
 * 
 * Uses next templates (https://github.com/blueimp/JavaScript-Templates) with
 * arguments:
 *  template-uploaded (files) - prints rows with detailed info about uploaded files
 *  template-list-element (files) - adds files info to list where it can be chosen (usually select tag) 
 * 
 * Settings (data-attributes):
 *  [data-upload='form'] - root element of form with additional settings:
 *      [data-type='/type_id/'] - type of files, e.g. 'my_foo_bar', used to bind form to filelist
 *      [data-action='/url/'] - form-action which will be called on submit
 *      .progress-bar - element with width as progress bar
 *  [data-upload='status'] - element which holds list of files or additional information
 *                           about upload progress. 
 *      .files - element holding list of uploaded files (usually table tag)
 *  [data-upload='clean-status'] - 'onclick' action will be assigned to this element
 *                                 This action will clean 'status' element
 *  [data-upload='list] - select tag with options (list) of uploaded files to choose. 
 *                        Option will be added on every successful file upload
 *      [data-type='/type_id/'] - type of files in list according to type in form
 *  
 * NOTE fileupload submits the nearest form with all inputs
 */
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
                    $list.append(tmpl('template-list-element', data.result));
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
