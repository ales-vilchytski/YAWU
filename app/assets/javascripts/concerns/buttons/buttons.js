(function() {
    var $pageUp = $('body');
    var $pageDown = $('body *').filter(':last');
    
    concerns.inheritWidgetBase('button', {
        options: {
          type: 'submit',    
        },
        
        _create: function() {
            switch(this.options.type) {
            case 'up':
                this._on({
                   'click': function() {
                       scrollTo($pageUp);
                   }
                });
                break;
            case 'down':
                this._on({
                    'click': function() {
                        scrollTo($pageDown);
                    }
                })
                break;
            case 'submit':
                break;
            };
        }
    
    });

})();
