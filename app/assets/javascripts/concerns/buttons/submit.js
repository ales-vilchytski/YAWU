module('concerns.buttonSubmit', ['concerns', '$'], function(concerns, $) {
    return concerns.inheritWidgetBase('buttonSubmit', $.ui.button, {});
});
