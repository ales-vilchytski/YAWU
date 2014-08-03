(function() {
    concerns.inheritWidgetBase('uploadList', {
        options: {
            type: null
        },
        
        _create: function() {
            var $list = $('select', this.element);   
            
            this.addFiles = function(files) {
                $list.append(tmpl('template-list-element', { files: files }));
            };
        },
        
    });
})();