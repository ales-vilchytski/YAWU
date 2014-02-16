/** 
* Declares "namespace" through creating object fields of 'this'. Typical usage:
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
        creator.apply(ns, name);
    }
    return ns;
};