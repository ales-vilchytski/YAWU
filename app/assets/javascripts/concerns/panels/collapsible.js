module('concerns.panelCollapsible', ['concerns', 'concerns.creator', 'concerns.panelBase'], function(concerns, creator) {
    return concerns.inheritWidgetBase('panelCollapsible', $.concerns.panelBase, {        
        _create: function() {
            this._super();
            var $header = this._getHeader$();
            var shownText = $header.data('panelHeaderShown');
            var hiddenText = $header.data('panelHeaderHidden');
            
            var $body = this._getBody$();
            
            var $collapseIcon = $('[data-panel-collapse]', this.widget());
            var shownClass = $collapseIcon.data('panelShown');
            var hiddenClass = $collapseIcon.data('panelHidden');
            
            $collapseIcon.on('click', function() {
               $body.collapse('toggle'); 
            });
            $header.on('click', function() {
               $body.collapse('toggle'); 
            });
            
            $body.collapse();
            $body.on('shown.bs.collapse', function() {
                $header.text(shownText);
                $collapseIcon.attr('class', shownClass);
                
                // Some widgets may need refresh on visible changed, e.g. Ace
                creator.createWidgetsOf($body).forEach(function(widget) {
                    if (widget.refresh) {
                        widget.refresh();
                    }
                });
            });
            $body.on('hidden.bs.collapse', function() {
                $header.text(hiddenText);
                $collapseIcon.attr('class', hiddenClass);
            });
            
            this.collapseShow = function() {
                $body.collapse('show');
            };
            
            this.collapseHide = function() {
                $body.collapse('hide');
            };
            
            this.collapseToggle = function() {
                $body.collapse('toggle');
            };
        }
    });
});