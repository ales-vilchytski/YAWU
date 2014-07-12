namespace('panels', function() {
    function Panel(id) {
        var $container = $('#' + id);
        var type = $container.data('panel');
        
        var $header = $('[data-panel-header]', $container);
        var $body = $('[data-panel-body]', $container);
        
        var defaultHeader = $header.data('panelHeader');
        var defaultBody = $body.data('panelBody');
        
        switch(type) {
        case 'plain':
            var $collapseIcon = $('#' + id + '_form_panel_collapse_icon');
            var shownClass = $collapseIcon.data('panelShown');
            var hiddenClass = $collapseIcon.data('panelHidden');
            
            $body.on('shown.bs.collapse', function() {
                $collapseIcon.attr('class', shownClass);
            });
            $body.on('hidden.bs.collapse', function() {
                $collapseIcon.attr('class', hiddenClass);
            });
            break;
        case 'error':
            var $collapseTarget = $($('[data-target]', $container).data('target'));
            
            this.show = function(title, text) {
                $header.text(title || defaultHeader);
                $body.text(text || defaultBody);
                
                $collapseTarget.collapse('show');
            };
            
            this.hide = function() {
                $collapseTarget.collapse('hide');
            }
            break;
        default:
            //TODO log error
        }
               
        this.getId = function() {
            return $container.attr('id');
        };

        this.getContainer = function() {
            return $container;
        };
        
        this.setHeader = function(header) {
            $header.text(header);
        };
        
        this.getHeader = function() {
            return $header.text();
        };
        
        this.setBody = function(body) {
            $body.text(body);
        };
        
        this.getBody = function() {
            return $body.text();
        };
        
    };
        
    var instances = {};

    this.widget = function(id) {
        if (instances[id]) {
            return instances[id];
        } else {
            var widget = new Panel(id);
            instances[widget.getId()] = widget;
            return widget;
        }
    };
    
});

$(document).ready(function() {
    $('[data-panel]').each(function(i, container) {
        var $element = $(container);
        if (!$element.attr('id')) {
            $element.attr('id', 'panel' + i);
        }
        panels.widget($element.attr('id'));
    }); 
});
