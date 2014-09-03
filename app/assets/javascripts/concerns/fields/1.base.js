(function() {
    concerns.inheritWidgetBase('fieldBase', {
        _create: function() {
            this._super();
            
            var $input = $('input', this.element);
            
            this.getInput = function() {
                return $input;
            };
            
            this.getValue = function() {
                return $input.val();
            };
            
            this.setValue = function(val) {
                $input.val(val);
            };
       },
    });
})();