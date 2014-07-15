(function() {
    concerns.inheritWidgetBase('panelForm', {        
        _create: function() {
            var id = this.getId();
            var $header = $('[data-panel-header]', this.widget());
            var $body = $('[data-panel-body]', this.widget());
            
            var $collapseIcon = $('#' + id + '_form_panel_collapse_icon', this.widget());
            var shownClass = $collapseIcon.data('panelShown');
            var hiddenClass = $collapseIcon.data('panelHidden');
            
            $body.on('shown.bs.collapse', function() {
                $collapseIcon.attr('class', shownClass);
            });
            $body.on('hidden.bs.collapse', function() {
                $collapseIcon.attr('class', hiddenClass);
            });
            
            this._getHeader$ = function() {
                return $header;
            };
            
            this._getBody$ = function() {
                return $body;
            };
            
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