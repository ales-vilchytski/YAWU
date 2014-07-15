(function() {
    concerns.inheritWidgetBase('panelError', $.concerns.panelForm, {     
        _create: function() {
            this._super();
            
            var $header = this._getHeader$();
            var $body = this._getBody$();
            
            var defaultHeader = $header.data('panelHeader');
            var defaultBody = $body.data('panelBody');
            var $collapseTarget = $($('[data-target]', this.widget()).data('target'));
                
            this.show = function(title, text) {
                $header.text(title || defaultHeader);
                $body.text(text || defaultBody);
                
                $collapseTarget.collapse('show');
            };
            
            this.hide = function() {
                $collapseTarget.collapse('hide');
            }
            
            this.setDefaultHeader = function(header) {
                $header.data('panelHeader', header);
            };
            
            this.getDefaultHeader = function() {
                return $header.data('panelHeader');
            };
            
            this.setDefaultBody = function(body) {
                $body.data('panelBody', body);
            };
            
            this.getDefaultBody = function() {
                return $body.data('panelBody');
            };
        }
    });
})();
