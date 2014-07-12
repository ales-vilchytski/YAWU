namespace('buttons', function() {
    var $pageUp = $('body');
    var $pageDown = $('body *').filter(':last');
        
    widgets.inheritWidgetBase(this, 'button', function (id, clazz) {
        var $container = $('#' + id);
        
        switch(clazz) {
        case 'up':
            $container.on('click', function() {
                scrollTo($pageUp);
            });
            break;
        case 'down':
            $container.on('click', function() {
                scrollTo($pageDown);
            })
            break;
        case 'submit':
            break;
        };  
    });

});
