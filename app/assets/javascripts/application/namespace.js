/** 
* Declares "namespace" through creating object fields of 'this' ('window' by default).
* Typical usage:
* <ul>
*  <li>namespace('fully.qualified.name', function() { fully.qualified.name.obj = 1; })</li>
*  <li>namespace('fully.qualified.name'); fully.qualified.name.obj = 2;
*  <li>namespace.call(context, 'fully.qualified.name') //for local namespaces
* </ul>
* This code can be used in client or server-side JS.
* 
* @param {string} name - dot separated parts of fully qualified namespace (like in Java)
* @param {function} creator - function callback which be called after creation of 
* namespace with 'this' setted to namespace
* @returns {object} - created namespace object
*/
this.namespace = function(name, creator) {

    var parts = name.split('.');
    var ns = this;
    for ( var i in parts) {
        if (ns[parts[i]]) {
            ns = ns[parts[i]];
            continue;
        } else {
            ns[parts[i]] = {};
            ns = ns[parts[i]];
        }
    }

    if (creator) {
        creator.call(ns, name);
    }
    return ns;
};

/**
 * Methods for dependency management. Solves JS-file load order problems.
 * Use modulejs functions, see API: http://larsjung.de/modulejs/
 *
 * Context for sources is 'window'.
 * Example with 'namespace':
 * 
 * // source1.js
 * source('source1', function() { 
 *     namespace('my.namespace', function() {
 *         this.val = 'some val';
 *     };
 * });
 * 
 * // source2.js
 * source('source2', ['source1'], function(source1return) {
 *     if (needed) {
 *         include('anotherSource'); // dependencies may be included at any time
 *     }
 *     namespace('another.namespace', function() {
 *         this.val = my.namespace.val + 1;
 *     };
 * });
 * 
 * // somewhere_in_global.js
 * include('source2');
 * alert(another.namespace.val);
 * 
 */
this.source = modulejs.define;
this.include = modulejs.require;