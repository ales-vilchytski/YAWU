module Features
  module Concerns
    module Uploads
      extend ActiveSupport::Concern
      include Features::Concerns::Common
      
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
         
      def upload_file(label, path, opts = {})
        opts = {
          in_widget: 'panel',
        }.merge(opts);
        
        input_id = "#{get_upload_form_id(label, opts)}_file_input"
        
        file_path = path.gsub('/', File::ALT_SEPARATOR || File::SEPARATOR)
        find(:file_field, input_id, visible: false).set(file_path)
      end
          
      def upload_status_should_contain(text, label, opts = {})
        opts = {
          in_widget: 'panel',
        }.merge(opts);
        
        form_id = get_upload_form_id(label, opts)
        expect(find(:css, "##{form_id} div[data-uploads='status']")).to have_content(text)
      end
  
      #====================================#
      
      def get_upload_form_id(label, opts)
        opts = {
          in_widget: 'panel',
          contains: '',
        }.merge(opts);
        
        container_id = get_widget_id_by_content(opts[:in_widget], label)
        return get_widget_id_in_container('uploadForm', container_id, { contains: opts[:contains] })
      end
      
    end
  end
end