module Uploads
  class BicryptFile < UploadedFile
    
    validates_attachment_content_type :uploaded, :content_type => /(octet\-stream)|(text)\Z/
    validates_attachment_file_name :uploaded, :matches => /\.(db3)|(key)\Z/
    
  end
end
