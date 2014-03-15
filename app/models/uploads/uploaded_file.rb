module Uploads
  class UploadedFile < ActiveRecord::Base
    
    has_attached_file :uploaded, path: ':rails_root/uploads/:class/:id/:filename'
    
    # By default paperclip doesn't allow to omit validation of name and content-type
    # This class can't be used as model holding files, it just adds common methods
    # and settings. You should define your own validations in subclasses
    
    def read
      File.read(uploaded.path)
    end
    
  end
end
