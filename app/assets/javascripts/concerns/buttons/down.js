(function() {
    var $pageDown = $('body *').filter(':last');
    concerns.inheritWidgetBase('buttonDown', $.ui.button, {
        _create: function() {
            this._super();
            this._on({
                'click': function() {
                    scrollTo($pageDown);
                }
            })
        },
     });
})();
