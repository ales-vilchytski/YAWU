namespace('concerns', function() {
    /**
     * Registered (inherited) widgets
     */
    this.widgetClasses = [];
    
    /**
     * Namespace of widgets:
     *   * $.concerns./widget/ - in JS
     *   * [data-concerns='/widget/'] - in HTML data-attributes
     */
    this.NAMESPACE = 'concerns';
    
    /**
     * Base class for widgets using Bootstrap 3
     */
    this.Base = function() {
        $.Widget.call(this);
    };
    this.Base.prototype = $.extend($.Widget.prototype, {
        getId: function() {
            return this.element.attr('id');
        },
        show: function() {
            this.element.removeClass('hidden');
        },
        hide: function() {
            this.element.addClass('hidden');
        },
        refresh: function() {
            // called when widget needs to be refreshed
        }
    });
    //workaround for $.Widget._childConstructors
    this.Base._childConstructors = $.Widget._childConstructors;
    
    /**
     * Creates jQueryUI widget (plugin) with specified name and prototype object.
     * All inherited widgets can be instantiated:
     *  * concerns./widget/(id, options)
     *  * or all at once - this.createWidgets()
     *  * plain jQuery-UI API can be used - $()./widget/(options_or_method)
     *
     * @see http://api.jqueryui.com/jQuery.widget
     */
    this.inheritWidgetBase = function(clazz, /*optional*/_widgetBase, _widgetPrototype) {
        var widgetPrototype = _widgetPrototype || _widgetBase;
        var widgetBase = _widgetPrototype ? _widgetBase : concerns.Base;
        
        $.widget(
            this.NAMESPACE + '.' + clazz, 
            widgetBase,
            widgetPrototype);
        
        this.widgetClasses.push(clazz);
        
        this[clazz] = function(id, options) {
            // Note, we use only id to reference element. No exceptions!
            // If we use selectors there are many possibilities to occasionally
            // manipulate group of widgets as single item
            var $element = $('#' + id);
            var instance = $element[clazz]('instance');
            
            if (!instance) {
                $element[clazz](options); //creates widget: $(...).clazz(options)
                instance = $element[clazz]('instance');
            }
            return instance;
        };
    };
    
    /**
     * After calls of inheritWidgetBase there are methods:
     * 
     * this.[widgetClass] = function(id, *options) { return new_or_existing_widget  }
     */
        
    /**
     * Creates or returns widgets (marked by [data-concerns='/widget/']) in specified 
     * element.Options for every widget include:
     *   * values from [data-concerns-options='/json/']
     * 
     * Returns array of created or existing instances.
     * 
     * @example concerns.createWidgetsOf('html') //creates and returns all widgets.
     */
    this.createWidgetsOf = function(container) {
        var $container = $(container);
        var widgets = [];
        $('[data-' + concerns.NAMESPACE + ']', $container).each(function(i, element) {
           var $element = $(element);
           var id = $element.attr('id');
           if (!id) {
               $element.uniqueId();
               id = $element.attr('id');
           }
           
           var clazz = $element.data(concerns.NAMESPACE);
           var options = $element.data(concerns.NAMESPACE + "Options");
           
           if (concerns.widgetClasses.indexOf(clazz) != -1) {
               widgets.push(concerns[clazz](id, options));
           }
        });
        return widgets;
    };
    
    /**
     * Creates or returns widgets for all HTML-elements.
     */
    this.createWidgets = function() {
        return this.createWidgetsOf('html');
    };
});
