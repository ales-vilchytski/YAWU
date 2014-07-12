namespace('widgets', function() {

    var widgetFactories = {};
    var instances = {};
    
    /**
     * Base class for widgets, which contains most common functionality
     */
    this.Base = function(id, clazz) {
        var $container = $('#' + id);
        //TODO check existence of element
        
        this.getId = function() {
            return $container.attr('id');
        };
        
        this.getContainer = function() {
           return $container;
        };
    };
    
    /**
     * Method for inheriting widgets.Base class and registering inherited constructor
     */
    this.inheritWidgetBase = function(namespace, type, constructor) {
        widgetFactories[type] = constructor;
        constructor.prototype = this.Base;
        namespace.widget = function(id) {
            return widgets.widget(id, type);
        };
    };
    
    /**
     * Retrieve or create widget for element with id and widget-type (e.g. 'button')
     */
    this.widget = function(id, type) {
        if (instances[id]) {
            return instances[id];
        } else {
            var constructor = widgetFactories[type];
            var widget = new this.Base(id, type);
            var type = widget.getContainer().data(type);
            constructor.call(widget, id, type);
            
            instances[widget.getId()] = widget;
            
            return widget;
        }
    };

    /**
     * Creates all registered widgets on page
     */
    $(document).ready(function() {
        var type;
        for (type in widgetFactories) {
            $('[data-' + type + ']').each(function(i, container) {
                var $element = $(container);
                if (!$element.attr('id')) {
                    $element.attr('id', type + '_' + i);
                }
                widgets.widget($element.attr('id'), type);
            });
        }
    });
});
