source('concerns/panelTabbed', ['concerns/concerns', 'concerns/panelBase'], function() {
    concerns.inheritWidgetBase('panelTabbed', $.concerns.panelBase, {
        _create: function() {
            this._super();
            var id = this.getId();
            var $header = this._getHeader$();
            var $tab_input = $('input[data-type="tab-input"]', $header);
            
            $('a[data-toggle="tab"]').on('shown.bs.tab', function() {
                var $atab = $(this);
                $tab_input.val($atab.data('value'));
            });
        
            /** TODO add functions:
             * - toggleTab(i)
             * - currentTab() -> int
             * 
             * and override:
             * - setHeader(text)
             * - setBody(text)
             */
            
            this.setHeader = function() { throw 'not implemented'; };
            this.setBody = function() { throw 'not implemented'; };
        },
         
    });
});