module('concerns.buttonUp', ['concerns', '$'], function(concerns, $) {
    var $pageUp = $('body');
    return concerns.inheritWidgetBase('buttonUp', $.ui.button, {
       _create: function() {
           this._super();
           this._on({
               'click': function() {
                   scrollTo($pageUp);
               }
           });
       },
    });
});
