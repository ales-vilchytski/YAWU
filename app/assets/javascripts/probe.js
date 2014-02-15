$(document).ready(function() {
    
    var input = ace.edit('input_editor');
    var output = ace.edit('output_editor');

    [ input, output ].forEach(function(editor) {
        editor.setTheme("ace/theme/eclipse");
        editor.getSession().setMode("ace/mode/xml");
    });

    $('#input_submit')
        .on('ajax:beforeSend', function(e, xhr, settings) {
            settings.contentType = 'text/xml';
            settings.data = input.getValue();
        })
        .on('ajax:success', function(e, data, status, xhr) {
            output.setValue(data.result);
         })
        .on('ajax:error', function(e, xhr, status, error) {
            output.setValue("ERROR\nStatus: "
                    + JSON.stringify(status) + "\nXHR: "
                    + JSON.stringify(xhr) + '\nerr: '
                    + JSON.stringify(error));
        });
});
