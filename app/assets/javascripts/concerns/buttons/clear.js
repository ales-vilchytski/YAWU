source('concerns/buttonClear', ['concerns/concerns'], function() {
    concerns.inheritWidgetBase('buttonClear', $.ui.button, {
       _create: function() {
           this._super();
           
           var editorId = this.widget().data('editorId');
           var editorType = this.widget().data('editorType');

           this._on({
               'click': function() {
                   var editor = concerns[editorType];
                   if (!editor) {
                       throw 'Unknown editor type (' + editorType + ')';
                   }
                   editor(editorId).setValue('');
               }
           });
       },
    });
});
