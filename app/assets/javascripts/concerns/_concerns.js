namespace('concerns', function() {
    /**
     * Registered (inherited) widgets
     */
    this.widgetClasses = [];
    
    /**
     * Namespace of widgets:
     *   * $.concerns_ui./widget/ - in JS
     *   * [data-concerns-/widget/='/type/'] - in HTML data-attributes
     */
    this.NAMESPACE = 'concerns';
    this.INT_SUFFIX = 'ui';
    
    /**
     * Base class for widgets using Bootstrap 3
     */
    this.Base = function() {
        $.Widget.call(this);
    };
    this.Base.prototype = $.extend($.Widget.prototype, {
        show: function() {
            this.element.removeClass('hidden');
        },
        hide: function() {
            this.element.addClass('hidden');
        }
    });
    //workaround for $.Widget._childConstructors
    this.Base._childConstructors = $.Widget._childConstructors;
    
    /**
     * Creates jQueryUI widget (plugin) with specified name and prototype object.
     * All inherited widgets can be instantiated with this.createWidgets.
     *
     * @see http://api.jqueryui.com/jQuery.widget
     */
    this.inheritWidgetBase = function(clazz, widgetPrototype) {
        $.widget(
            this.NAMESPACE + '_' + this.NAMESPACE_SUFFIX + '.' + clazz, 
            concerns.Base,
            widgetPrototype);
        
        this.widgetClasses.push(clazz);
                
        this[clazz] = function(id, options) {
            var $element = $('#' + id);
            var instance = $element[clazz]('instance');
            
            if (!instance) {
                var camelName = this.NAMESPACE + clazz.replace(/^(.)/, function (match, c) {
                    return c.toUpperCase();
                });
                
                var _options = $.extend({
                        type : $element.data(camelName),
                    },
                    $element.data(this.NAMESPACE + 'Options'),
                    options);
                
                $element[clazz](_options); //creates widget: $(...).clazz(options)
            }
            return $element[clazz]('instance');
        };
    };
    
    /**
     * After calls of inheritWidgetBase there are methods:
     * 
     * this.[widgetClass] = function(id, *options) { return new_or_existing_widget  }
     */

    /**
     * Creates widgets for all HTML-elemnts with [data-concerns-/name/=/type/]
     * Options for every widget include:
     *   * value of data-concerns-/name/ as options.type
     *   * json from [data-concerns-options] (overriding options.type if any)
     */
    this.createWidgets = function() {
        this.widgetClasses.forEach(function(clazz) {
            $('[data-' + this.NAMESPACE + '-' + clazz + ']').each(function(i, container) {
                var $element = $(container);
                if (!$element.attr('id')) {
                    $element.uniqueId();
                }

                this[clazz]($element.attr('id'));
            });
        });
    };
});
