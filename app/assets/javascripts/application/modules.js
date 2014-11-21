/**
 * Wrap modulejs functions for simplicity or future replacement
 * See API: http://larsjung.de/modulejs/
 */
this.module = modulejs.define;
this.include = modulejs.require;


/**
 * Existing libraries bindings
 */
module('$', function() {
   return jQuery; 
});
