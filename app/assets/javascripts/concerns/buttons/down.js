module('concerns.buttonDown', ['concerns', '$'], function(concerns, $) {
    var $pageDown = $('body *').filter(':last');
    return concerns.inheritWidgetBase('buttonDown', $.ui.button, {
        _create: function() {
            this._super();
            this._on({
                'click': function() {
                    scrollTo($pageDown);
                }
            });
        },
     });
});
