module('concerns.uploadForm', ['concerns'], function(concerns) {
    return concerns.inheritWidgetBase('uploadForm', {
        options: {
            action: null,
            type: null
        },
        
        _create: function() {
            this._super();
            var $form = this.widget();
            var type = this.options['type'];
            var action = this.options['action'];
            
            var $tooltip = $('[data-toggle="tooltip"]', $form);
            var $progressBar = $('.progress-bar', $form);
            var $status = $('[data-uploads="status"]', $form);
            var $cleanStatus = $('[data-uploads="clean-status"]', $form);
            var $files = $('.files', $status);
            
            var uploadsLists = [];
            
            $tooltip.tooltip();
            
            $form.fileupload({
                dataType: 'json',
                dropZone: $form,
                url: action,
                start: function (e) {
                    $progressBar.css('width', '0%');
                    $tooltip.tooltip('hide');
                },
                done: function (e, data) {
                    $status.collapse('show');
                    $files.append(tmpl('template-uploaded', data.result));
                    
                    uploadsLists.forEach(function(list) {
                        list.addFiles(data.result.files.filter(function(file) { return file.error == null; }));
                    });
                },
                fail: function(e, data) {
                    $status.collapse('show');
                    $files.append(tmpl('template-fail-element', data));
                },
                progressall: function (e, data) {
                    var progress = parseInt(data.loaded / data.total * 100, 10);
                    $progressBar.css('width', progress + '%');
                },
                stop: function (e) {
                    setTimeout(function() { $progressBar.css('width', '0%'); }, 1.5e+3);
                }
            });
            
            $cleanStatus.on('click', function(e) {
                $status.collapse('hide');
                $files.empty();
                $progressBar.css('width', '0%');
            });
            
            
            this.addUploadList = function(uploadsList) {
                uploadsLists.push(uploadsList);
            };
            
            this.getUploadLists = function() {
                return uploadsLists;
            };
        },
    });
});