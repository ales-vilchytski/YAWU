namespace('editors', function() {
    function AceEditor(id) {
        var $container = $('#' + id);
        var type = $container.data('editor_ace');

        //TODO assert invariant
        
        var editor = ace.edit($container.attr('id'));
        
        switch (type) {
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
        
        this.getId = function() {
            return $container.attr('id');
        };

        this.getContainer = function() {
            return editor.container;
        };
        
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
        }
        
    };

    var instances = {};

    this.widget = function(id) {
        if (instances[id]) {
            return instances[id];
        } else {
            var widget = new AceEditor(id);
            instances[widget.getId()] = widget;
            return widget;
        }
    };

});

$(document).ready(function() {
    $('[data-editor_ace]').each(function(i, container) {
        var $element = $(container);
        if (!$element.attr('id')) {
            $element.attr('id', 'editor_ace' + i);
        }
        editors.widget($element.attr('id'));
    });
})
