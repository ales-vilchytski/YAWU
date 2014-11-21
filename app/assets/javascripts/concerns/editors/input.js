module('concerns.editorInput', ['concerns', 'concerns.editorBase'], function(concerns) {
    return concerns.inheritWidgetBase('editorInput', $.concerns.editorBase, {
       _create: function() {
           this._super();
           
           var $input = $('#ace_text_area_' + this.getId());
           var editor = this.getAce();
           
           var sync = function() {
               $input.val(editor.getValue());
           };
           
           sync();
           editor.addEventListener('change', sync);
       },
    });
});