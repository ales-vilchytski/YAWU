(function() {
    concerns.inheritWidgetBase('panel', {
        options: {
            type: 'plain',
        },
        
        _create: function() {
            var id = this.widget().attr('id');
            var $header = $('[data-panel-header]', this.widget());
            var $body = $('[data-panel-body]', this.widget());
            
            var defaultHeader = $header.data('panelHeader');
            var defaultBody = $body.data('panelBody');
            
            switch(this.options.type) {
            case 'plain':
                var $collapseIcon = $('#' + id + '_form_panel_collapse_icon', this.widget());
                var shownClass = $collapseIcon.data('panelShown');
                var hiddenClass = $collapseIcon.data('panelHidden');
                
                $body.on('shown.bs.collapse', function() {
                    $collapseIcon.attr('class', shownClass);
                });
                $body.on('hidden.bs.collapse', function() {
                    $collapseIcon.attr('class', hiddenClass);
                });
                break;
            case 'error':
                var $collapseTarget = $($('[data-target]', this.widget()).data('target'));
                
                this.show = function(title, text) {
                    $header.text(title || defaultHeader);
                    $body.text(text || defaultBody);
                    
                    $collapseTarget.collapse('show');
                };
                
                this.hide = function() {
                    $collapseTarget.collapse('hide');
                }
                break;
            default:
                //TODO log error
            }
                    
            this.setHeader = function(header) {
                $header.text(header);
            };
            
            this.getHeader = function() {
                return $header.text();
            };
            
            this.setBody = function(body) {
                $body.text(body);
            };
            
            this.getBody = function() {
                return $body.text();
            };
        }
        
    });

})();

