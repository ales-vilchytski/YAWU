source('concerns/buttonUp', ['concerns/concerns'], function() {
    var $pageUp = $('body');
    concerns.inheritWidgetBase('buttonUp', $.ui.button, {
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
