namespace('editors', function() {
    widgets.inheritWidgetBase(this, 'editor_ace', function (id, clazz) {
        var $container = $('#' + id);
        
        var editor = ace.edit($container.attr('id'));
        
        var _settings = $container.data('editor_aceSettings') || {};
        var settings = {
            readOnly: _settings['readOnly'] || false,
            mode: _settings['mode'] || 'xml',
            theme: _settings['theme'] || 'eclipse'
        }
        
        switch (clazz) {
        case 'output':
            break;
        case 'input':
            var $input = $('#ace_text_area_' + $container.attr('id'));
            var sync = function() {
                $input.val(editor.getSession().getValue());
            }
            sync();
            editor.addEventListener('change', sync);
            break;
        default:
            //TODO log error 
        }
                
        this.getAce = function() {
            return editor;
        };
        
        this.getValue = function() {
            return editor.getSession().getValue();
        };
        
        this.setValue = function(value) {
            editor.getSession().setValue(value);
        };
        
        this.getReadOnly = function() {
            return editor.getReadOnly();
        };
        
        this.setReadOnly = function(readOnly) {
            editor.setReadOnly(readOnly);
            editor.container.style.opacity = readOnly ? 0.5 : 1;
        };
        
        this.setMode = function(mode) {
            editor.getSession().setMode('ace/mode/' + mode);
        };
        
        this.setTheme = function(theme) {
            editor.setTheme('ace/theme/' + theme);
        };        

        this.setReadOnly(settings['readOnly']);
        this.setMode(settings['mode']);
        this.setTheme(settings['theme']);
    });

});
