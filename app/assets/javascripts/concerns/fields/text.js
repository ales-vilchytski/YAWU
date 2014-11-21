module('concerns.fieldText', ['concerns', 'concerns.fieldBase'], function(concerns) {
    return concerns.inheritWidgetBase('fieldText', $.concerns.fieldBase, {
        options: {
           tabAllowed: false,
        },
       
        _create: function() {
            this._super();
            
            var $input = this.getInput();
            
            if (this.option('tabAllowed') == true) {
                $input.on('keydown', function(e) {
                    if(e.which == 9 && e.target == this) {
                        var input = $(this);
                        var start = this.selectionStart, end = this.selectionEnd;
                        var current = input.val();
                        
                        var result = current.slice(0, start) + '\t' + current.slice(end);
                        input.val(result);
                        
                        this.selectionStart = start + 1;
                        this.selectionEnd = start + 1;
                        
                        e.preventDefault();
                    }
                });
            }
       },
    });
});