module Features
  module Concerns
    module Common
      extend ActiveSupport::Concern
      include ActionView::Helpers::JavaScriptHelper
      include Features::Common
    
      # Checks all widgets on page and returns id of one with specified content
      # (by selector :contains)
      # E.g. to find panel (regardless exact class such panelError or panelTabbed) with text 
      # 'Text in panel' (in whole panel) use:
      #  get_widget_id_by_content('panel', 'Text in panel')
      # Throws error unless there is exactly 1 widget 
      #
      # @param widget [String] beginning of name of widget class
      # @param content [String] content to search
      # @return [String] id of widget 
      def get_widget_id_by_content(widget, content)
        script = %Q{return (function() {
            var $widget = $('[data-concerns*="#{j widget}"]:contains("#{j content}")');
          
            var id = $widget.attr('id');
            if ($widget.length != 1) {
              throw "Found 0 or more than 1 #{j widget} with #{j content.truncate(50)}";
            } else if (!id) {
              throw "There is no ID for #{j widget} with #{j content.truncate(50)}";
            }
            return id;
        })();}
        return page.execute_script(script)
      end
      
      # Checks container widget with specified id to have another widget inside.
      # Returns id of found widget, throws error unless there is exactly 1 widget
      #
      # @param widget [String] beginning of name of widget class
      # @param container_id [String] id of parent container
      # @param oprs [Hash] additional options: +contains+ specifies text in widget to contain
      # @return [String] id of widget
      def get_widget_id_in_container(widget, container_id, opts = {})
        opts = {
          contains: '',
        }.merge(opts)
        
        script = %Q{return (function() {
            var $widget = $('[data-concerns*="#{j widget}"]:contains("#{j opts[:contains]}")', $('##{j container_id}'));
          
            var id = $widget.attr('id');
            if ($widget.length != 1) {
              throw "Found 0 or more than 1 #{j widget} in container ##{j container_id} with content #{j opts[:contains].truncate(50)}";
            } else if (!id) {
              throw "There is no ID for #{j widget} in container ##{j container_id} with content #{j opts[:contains].truncate(50)}";
            }
            return id;
        })();}
        return page.execute_script(script)
      end
      
      # Returns JS snippet suitable for inclusion on other script. Snippet returns
      # widget object with specified id (or throws error unless there is exactly 
      # 1 widget found)
      # E.g. include in script to find input editor #input:
      #  var widgetInputEditor = #{script_get_widget_by_id('editorInput', 'input')};
      #
      # @param widget [String] beginning of name of widget class
      # @param id [String]
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
                throw 'Widget #{j widget} with ID #{j id} not found or not created';
            }
            return widget;
        }())}
      end
    
    end
        
  end
end