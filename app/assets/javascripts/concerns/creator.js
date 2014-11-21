module('concerns.creator', ['concerns'], function(concerns) {
    return (function() {
    /**
     * Creates or returns widgets (marked by [data-concerns='/widget/']) in specified 
     * element. Requires widget if needed as module with name 'concerns./widget/'
     * Options for every widget include:
     *   * values from [data-concerns-options='/json/']
     * 
     * Returns array of created or existing instances.
     * 
     * @example concernsCreator.createWidgetsOf('html') //creates and returns all widgets.
     */
    this.createWidgetsOf = function(container) {
        var $container = $(container);
        var widgets = [];
        $('[data-' + concerns.NAMESPACE + ']', $container).each(function(i, element) {
           var $element = $(element);
           $element.uniqueId();
           var id = $element.attr('id');
           
           var clazz = $element.data(concerns.NAMESPACE);
           var options = $element.data(concerns.NAMESPACE + "Options");
           
           try {
               include(concerns.NAMESPACE + '.' + clazz);
               widgets.push(concerns[clazz](id, options));
           } catch (notLoaded) {
               logger.error(notLoaded);
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
    
    return this;
    
    }).call({});
});
