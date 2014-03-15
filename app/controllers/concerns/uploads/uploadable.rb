module Uploads
  
  # Module provides implementation of controller-concern for uploading files
  # Just include this module and define method 'upload_class' returning actual 
  # model class for uploads (should extend Uploads::UploadedFile)
  # In typical case You need only one upload form per page. In this case you can use
  # partials from concerns/uploads without extra settings.
  module Uploadable
    extend ActiveSupport::Concern
    
    included do
      # Action processing file upload.
      # Needs instance method 'upload_class' returning actual class of upload model
      def upload
        do_upload(upload_class)
      end
      
      # Useful method for views with file upload form to set file type automagically
      def upload_type
        upload_class.name.underscore
      end
      
      helper_method :upload_type
      
      protected
      
      # Implementation of uploading files
      # TODO implement common JSON interface for results
      # 
      # @upload_claz [Class, #read] - class (constant) extending Uploads::UploadedFile
      def do_upload(upload_claz)
        uploaded_files_info = { files: [] }
        params['files'].each do |file|
          uf = Uploads::UploadedFile.new()
          
          if (!(upload_claz && upload_claz.is_a?(Class) && upload_claz < Uploads::UploadedFile))
            raise ArgumentError.new("Upload class should be class extending #{Uploads::UploadedFile.name}")
          end
          uf = uf.becomes(upload_claz)
          
          uf.type = upload_claz.name
          uf.uploaded = file.tempfile
          uf.uploaded_file_name = file.original_filename
          
          if uf.save
            uploaded_files_info[:files] << to_jq_fileupload(uf)
          else
            uploaded_files_info[:files] << to_jq_upload_error(uf)
          end
        end
        render :json => uploaded_files_info
      end
      
      # Returns JSON representing information about uploaded file
      #
      # @uploaded [Uploads::UploadedFile, #read] - instance of uploaded file
      def to_jq_fileupload(uploaded)
        return {
          id: uploaded.read_attribute(:id),
          scope: uploaded.read_attribute(:scope),
          name: uploaded.read_attribute(:uploaded_file_name),
          size: uploaded.read_attribute(:upload_file_size),
          url: uploaded.uploaded.url(:original) 
        }
      end

      # Returns JSON representing information about errors during upload process
      #
      # @uploaded [Uploads::UploadedFile, #read] - instance of uploaded file
      def to_jq_upload_error(uploaded)
        res = {
          name: uploaded.read_attribute(:uploaded_file_name),
          size: uploaded.read_attribute(:upload_file_size),
          error: uploaded.errors.full_messages
        }
        return res
      end
        
    end
  end
  
end