(function() {
    concerns.inheritWidgetBase('editorBase', {
        options: {
            readOnly: false,
            mode: 'ruby',
            theme: 'eclipse',
        },
        
        _create: function() {
            var id = this.getId();
            var editor = ace.edit(id);
                                            
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
            this.refresh();
        },
        
        refresh: function() {
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
