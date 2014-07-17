module Features
  module Concerns
    module Common
      extend ActiveSupport::Concern
      include ActionView::Helpers::JavaScriptHelper
      include Features::Common
    
      def get_widget_id_by_content(widget, content)
        script = %Q{return (function() {
            var $widget = $('[data-concerns*="#{j widget}"]:contains("#{j content}")');
          
            var id = $widget.attr('id');
            if ($widget.length > 1) {
              throw "Found more than 1 #{j widget} with #{j content.truncate(50)}";
            } else if (!id) {
              throw "There is no ID for #{j widget} with #{j content.truncate(50)}";
            }
            return id;
        })();}
        return page.execute_script(script)
      end
      
      def script_get_widget_by_id(widget, id)
        script = %Q{(function() {
            var $widget = $("[data-concerns*='#{j widget}']##{j id}");
            
            if ($widget.length > 1) {
              throw "Found more than 1 #{j widget} with ##{j id}";
            } else if ($widget.length == 0) {
              throw "There is no #{j widget} with ##{j id}";
            }
            var widgetClass = $widget.data('concerns');
            var widget = $widget[widgetClass]('instance');
            if (!widget) {
                throw 'Widget not found or not created';
            }
            return widget;
        }())}
      end
    
    end
        
  end
end