module Uploads
  
  class Xml::XsdFile < UploadedFile
    
    validates_attachment_content_type :uploaded, :content_type => /xml\Z/
    validates_attachment_file_name :uploaded, :matches => /\.(xsd)|(xml)\Z/
    
  end
  
end