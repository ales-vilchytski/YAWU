namespace('buttons', function() {
    var $pageUp = $('body');
    var $pageDown = $('body *').filter(':last');
    
    function Button(id) {
        var $container = $('#' + id);
        var type = $container.data('button');
        
        switch(type) {
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
        
        this.getId = function() {
            return $container.attr('id');
        }
        
        this.getContainer = function() {
           return $container;
        };
    };
    
    var instances = {};

    this.widget = function(id) {
        if (instances[id]) {
            return instances[id];
        } else {
            var widget = new Button(id);
            instances[widget.getId()] = widget;
            return widget;
        }
    };
});

$(document).ready(function() {
    $('[data-button]').each(function(i, container) {
        var $element = $(container);
        if (!$element.attr('id')) {
            $element.attr('id', 'button_' + i);
        }
        buttons.widget($element.attr('id'));
    });
})
