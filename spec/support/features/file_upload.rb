## DEPRECATED, use concerns and according helpers instead (Features::Concerns::Uploads)

module Features
  module FileUpload
    # depends on Features::Common
    
    def find_form_script(label)
      %Q{
          var $forms = $("[data-upload='form']");
          var $form = null;
          $forms.each(function(i, form) {
              $label = $(":contains(#{j label})", $forms);
              if ($label && $label[0]) {
                  $form = $(form);
              }
          });
          if (!$form || !$form[0]) {
              throw 'File upload form not found';
          }
      }
    end
    
    # Helper for error messages. Returns hash with common errors
    def invalid_file
      return {
        name: t('activerecord.attributes.uploads/uploaded_file.uploaded_file_name') + ' ' \
          + t('activerecord.errors.models.uploads/uploaded_file.attributes.uploaded_file_name.invalid'),
        content_type: t('activerecord.attributes.uploads/uploaded_file.uploaded_content_type') + ' ' \
          + t('activerecord.errors.models.uploads/uploaded_file.attributes.uploaded_content_type.invalid'),
      }
    end
    
    #===== Selectors and actions, matchers =========#
    # TODO move to Capybara selectors and actions, and to RSpec matchers. See implementation below
    
    def upload_file(label, path)
      find_input_id_script = %Q{return (function() {
          #{find_form_script(label)}
          var $input = $("input[type='file']", $form);
          return $input.attr('id');
        })();
      }
      input_id = page.execute_script find_input_id_script
      
      # File path should contain system specific path-separator. For Windows it's '\'
      file_path = path.gsub('/', File::ALT_SEPARATOR || File::SEPARATOR)
      
      find(:file_field, input_id, visible: false).set(file_path)
    end
    
    def upload_status_should_contain(text, label, opts = {})
      result = nil
      wait_until(opts) { (result = get_status_text(label)).include? text }
      result.should include(text)
    end
    
    #====================================#
    
    def get_status_text(label)
      get_status_text_script = %Q{return (function() {
          #{find_form_script(label)}
          var $status = $("[data-upload='status']", $form);
          return $status.text();
        })();
      }
      return execute_script get_status_text_script
    end
  end
end