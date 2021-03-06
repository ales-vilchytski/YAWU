source('concerns/concerns', function() {
    namespace('concerns', function() {
        /**
         * Registered (inherited) widgets for debug purposes
         */
        this.widgetClassNames = [];
        
        /**
         * Namespace of widgets for jQueryUI and data-attributes:
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
            var widgetBase = _widgetPrototype ? _widgetBase : this.Base;
            
            $.widget(
                this.NAMESPACE + '.' + clazz, 
                widgetBase,
                widgetPrototype);
            
            this.widgetClassNames.push(clazz);
            
            this[clazz] = function(id, options) {
                // Note, we use only id to reference element. No exceptions!
                // If we use selectors there are many possibilities to occasionally
                // manipulate group of widgets as single item
                var $element = $('#' + id);
                if ($element.length != 1) {
                    throw "There are " + $element.length + " elements with id '" + id + "'";
                }
                var instance = $element[clazz]('instance');
                
                if (!instance) {
                    $element[clazz](options); //creates widget: $(...).clazz(options)
                    instance = $element[clazz]('instance');
                }
                return instance;
            };
            return this[clazz];
        };
        
        
        /**
         * After calls of inheritWidgetBase there are methods:
         * 
         * this.[widgetClass] = function(id, *options) { return new_or_existing_widget  }
         */
        
        
        /**
         * Creates or returns widgets (marked by [data-concerns='/widget/']) in specified 
         * element. Requires widget if needed as module with name 'concerns/widget'
         * Options for every widget include:
         *   * values from [data-concerns-options='/json/']
         * 
         * Returns array of created or existing instances.
         * 
         * @example concerns.createWidgetsOf('html') //creates and returns all widgets.
         */
        this.createWidgetsOf = function(container) {
            var $container = $(container);
            var widgets = [];
            $('[data-' + this.NAMESPACE + ']', $container).each(function(i, element) {
               var $element = $(element);
               $element.uniqueId();
               var id = $element.attr('id');
               
               var clazz = $element.data(concerns.NAMESPACE);
               var options = $element.data(concerns.NAMESPACE + "Options");
               
               try {
                   include(concerns.NAMESPACE + '/' + clazz);
                   widgets.push(concerns[clazz](id, options));
               } catch (notCreated) {
                   logger.error(notCreated);
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
});
