module Uploads
  
  class Text::UrlCodingFile < UploadedFile
    
    validates_attachment_content_type :uploaded, :content_type => /(#{%w( text application\/xml application\/json application\/javascript ).join ")|("})\Z/
    validates_attachment_file_name :uploaded, :matches => /\.?.*\Z/
    
  end
  
end
