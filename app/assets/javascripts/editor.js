// require of ace moved to explicit javascript_include_tag's due to javascript-worker.js
// load failures (when ace loads it dynamically and sends request to wrong URL)
//
//= require_tree ./editor
''; // hack for YUI compressor issue, don't delete this line if there is no compilable content. See: https://github.com/yui/yuicompressor/issues/130