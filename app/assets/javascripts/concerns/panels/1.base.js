(function() {
    concerns.inheritWidgetBase('panelBase', {        
        _create: function() {
            var id = this.getId();
            var $header = $('[data-panel-header]', this.widget());
            var $body = $('[data-panel-body]', this.widget());
            
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