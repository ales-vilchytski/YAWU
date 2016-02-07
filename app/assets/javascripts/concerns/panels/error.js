source('concerns/panelError', ['concerns/concerns', 'concerns/panelBase'], function() {
    concerns.inheritWidgetBase('panelError', $.concerns.panelBase, {
        defaultOptions: {
            delayHide: 0,
            maxLengthBody: 300,
            maxLengthTitle: 200,
            extraEnding: '...'
        },

        _create: function() {
            this._super();

            var $header = this._getHeader$();
            var $body = this._getBody$();
            
            var defaultHeader = $header.data('panelHeader');
            var defaultBody = $body.data('panelBody');
            var $collapseTarget = $($('[data-target]', this.widget()).data('target'));
            $collapseTarget.collapse({ toggle: false });

            function setCutOffText($element, text, maxLength, ending) {
                var actualMaxLength = maxLength - ending.length;

                if (text.length > actualMaxLength) {
                    $element.text(text.substring(0, actualMaxLength));
                    $element.attr('title', text);
                    $element.tooltip({ placement: 'bottom' });
                } else {
                    $element.text(text);
                    $element.attr('title', '');
                    $element.tooltip('disable');
                }
            };

            this.show = function(title, text) {
                setCutOffText($header, title || defaultHeader, this.options.maxLengthTitle, this.options.extraEnding);
                setCutOffText($body, text || defaultBody, this.options.maxLengthBody, this.options.extraEnding);

                $collapseTarget.collapse('show');
                if (this.options.delayHide > 0) {
                    var self = this;
                    if (this._delayHideHandler) {
                        clearTimeout(this._delayHideHandler);
                    }
                    this._delayHideHandler = setTimeout(function() {
                        self.hide();
                    }, this.options.delayHide);
                }
            };
            
            this.hide = function() {
                if (this._delayHideHandler) {
                    clearTimeout(this._delayHideHandler);
                }
                $collapseTarget.collapse('hide');
            };
            
            this.setDefaultHeader = function(header) {
                $header.data('panelHeader', header);
            };
            
            this.getDefaultHeader = function() {
                return $header.data('panelHeader');
            };
            
            this.setDefaultBody = function(body) {
                $body.data('panelBody', body);
            };
            
            this.getDefaultBody = function() {
                return $body.data('panelBody');
            };
        }
    });
});
