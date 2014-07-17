module Features
  module Concerns
    module Editor
      extend ActiveSupport::Concern
      include Features::Concerns::Common
     
      #===== Selectors and actions, matchers =========#
      # TODO move to Capybara selectors and actions, and to RSpec matchers. See implementation below
      def fill_in_editor(label, opts)
        opts = {
          :in_widget => 'panel',
          :with => nil,
        }.merge(opts)
        
        script = %Q{(function() {
             #{script_get_editor_widget(label, opts)}.setValue("#{j opts[:with]}");
        }())}
        page.execute_script(script)
      end
      
      def editor_value_should_eq(expected, label, opts = {})
        opts = {
          :in_widget => 'panel',
          # :timeout => 5.seconds,
        }.merge(opts)
        
        result = nil
        wait_until(opts) { (result = get_editor_value(label, opts)) == expected }
        result.should == expected
      end

      #===============================================#
      
      def get_editor_value(label, opts)
        opts = {
          :in_widget => 'panel',
        }.merge(opts)
        
        script = %Q{return (function() {
            return #{script_get_editor_widget(label, opts)}.getValue();
        }());}
        return page.execute_script(script)
      end
      
      def script_get_editor_widget(label, opts)
        opts = {
          :in_widget => 'panel',
        }.merge(opts)
        
        in_widget_id = get_widget_id_by_content(opts[:in_widget], label)
        editor_id = page.execute_script %Q{return (function() {
            var $editor = $('[data-concerns*="editor"]', $("##{j in_widget_id}"));
            if ($editor.length != 1) {
                throw "There are 0 or more than 1 editor in widget '#{j opts[:in_widget]}' with ##{j in_widget_id}";
            }
            return $editor.attr('id');
        }());}
        
        return script_get_widget_by_id('editor', editor_id);
      end
      
    end
  end
end