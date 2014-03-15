module Uploads
  
  class XsdFile < UploadedFile
    
    validates_attachment_content_type :uploaded, :content_type => /xml\Z/
    validates_attachment_file_name :uploaded, :matches => /\.xsd\Z/
     
  end
  
end