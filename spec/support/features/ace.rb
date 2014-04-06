module Features
  module Ace
    include ActionView::Helpers::JavaScriptHelper
    # Also depends on Features::Common
    
    def get_ace_settings(label, type)
      script = %Q{return (function() \{
        var $heading = $('div.panel-heading:contains("#{j label}")');
        var $body = $heading.siblings('.panel-body');
        var $editorDiv = $('[data-editor="#{j type}"]', $body);
        var name = $editorDiv.data('editorSettings')['name'];
      
        var $form = $editorDiv.closest('form')
        var form = ($form.data('editorSettings') || {})['name'];
        return { 'name': name, 'form': form || '' };
      \})();}
      res = page.execute_script(script);
      return {
        form: res['form'],
        name: res['name'],
        type: type
      }
    end
    
    #===== Selectors and actions, matchers =========#
    # TODO move to Capybara selectors and actions, and to RSpec matchers. See implementation below
        
    def fill_in_editor(label, opts)
      set_ace_value(opts[:with], get_ace_settings(label, 'input'))
    end
    
    def get_editor_value(label)
      get_ace_value(get_ace_settings(label, 'output'))
    end
    
    def editor_value_should_eq(expected, label, opts = {})
      opts = {
        timeout: nil,
      }.merge(get_ace_settings(label, opts[:type] || 'output')).merge(opts || {})
      ace_value_should_eq(expected, opts)
    end
    
    #====================================#
    
    # Returns JS-string which finds Ace editor on page. This script contains
    # variable 'editor', which holds editor object from Ace API
    #
    # @param opts [Hash, #read] - options:
    #   :form - name of form in data-editor-settings
    #   :name - name of editor in data-editor-settings
    #   :type - 'input' or 'output'
    def js_finding_ace_editor(opts)
      form_attr_selector = if (opts[:form] != '' && opts[:form] != nil)
        j %Q{[data-editor-settings*="#{opts[:form]}"]}
      else
        ''
      end
      
      editor_attr_selector = if (opts[:name] != '' && opts[:name] != nil)
        j %Q{[data-editor-settings*="#{opts[:name]}"]}
      else
        ''  
      end
      
      script = %Q{
        var htmlForm = $('[data-editor="form"]#{form_attr_selector}')[0];
        var editor = $('[data-editor="#{opts[:type]}"]#{editor_attr_selector}', htmlForm)[0];
        if (!editor) {
          throw 'Editor element not found';
        }
        editor = ace.edit(editor);
      }
      return script
    end
    
    # Fills in Ace editor with text using it's API (through JS)
    #
    # @param value [String, #read] text
    # @param opts [Hash, #read] options of editor
    # @see #js_finding_ace_editor
    def set_ace_value(value, opts = {})
      opts = {
        form: '',
        name: 'input',
        type: 'input'
      }.merge(opts || {})
            
      script = js_finding_ace_editor(opts) + %Q{
        editor.setValue('#{j value}');
      }
      page.execute_script(script)
    end
    
    # Returns Ace editor value using it's API (through JS)
    #
    # @param opts [Hash, #read] options of editor
    # @see #js_finding_ace_editor
    def get_ace_value(opts = {})
      opts = {
        form: '',
        name: 'result',
        type: 'output'
      }.merge(opts || {})
      
      script = %Q{return (function() \{
        #{js_finding_ace_editor(opts)}
        return editor.getValue();
      \})();}
      page.execute_script(script)
    end
    
    # Asserts Ace editor value to be equal (==) to expected string. 
    # Waits at maximum default or specified timeout for AJAX transitions.
    # Raises exception if comparison fails.
    #
    # @param expected [String, #read] string to compare to
    # @param opts [Hash, #read] options of editor or :timeout in seconds
    # @see #js_finding_ace_editor
    def ace_value_should_eq(expected, opts = {})
      result = nil
      wait_until(opts) { (result = get_ace_value(opts)) == expected }
      result.should == expected
    end
    
  end
end