(function() {
    concerns.inheritWidgetBase('editor', {
        options: {
            type: 'input', //can't be changed
            readOnly: false,
            mode: 'ruby',
            theme: 'eclipse',
        },
        
        _create: function() {
            var id = this.widget().attr('id');
            var editor = ace.edit(id);
            
            switch (this.options.type) {
            case 'output':
                break;
            case 'input':
                var $input = $('#ace_text_area_' + id);
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
            
            this._setOptions(this.options);
        },
        
        show: function() {
            this._super();
            this.getAce().resize();
            this.getAce().renderer.updateFull();
        },
            
        _setOption: function(key, value) {
            var editor = this.getAce();
            switch(key) {
            case "readOnly":
                editor.setReadOnly(value);
                editor.container.style.opacity = value ? 0.5 : 1;
                break;
            case "mode":
                editor.getSession().setMode('ace/mode/' + value);
                break;
            case "theme":
                editor.setTheme('ace/theme/' + value);
                break;
            }
            this._super( key, value );
        },
    });
    
})();

