/**
 * Logger, implemented as a wrapper for Web Console API.
 * Methods use console only if it is available, otherwise do nothing.
 * 
 * logger.log(object);
 * logger.error(object);
 * ...
 */
(function() {
    var _consoleImp = this.console;
    
    var consoleCallIfExist = function(methodname, args) {
        if (_consoleImp && _consoleImp[methodname]) {
            return _consoleImp[methodname].apply(_consoleImp, args);
        }
    };
        
    this.logger = {};
    ['log', 'info', 'warn', 'error'].forEach(function(severity) {
        logger[severity] = function() {
            var args = Array.prototype.slice.call(arguments, 0);
            return consoleCallIfExist(severity, args);
        };
    });
}).call(window);
