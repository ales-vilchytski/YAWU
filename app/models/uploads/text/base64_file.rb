module Uploads
  
  class Text::Base64File < UploadedFile
    
    validates_attachment_content_type :uploaded, :content_type => /(#{%w( text application\/xml application\/json application\/javascript ).join ")|("})\Z/
    validates_attachment_file_name :uploaded, :matches => /\.?.*\Z/ # any
    
    def read_binary
      # Base64 works with bytes then read file as binary
      File.read(uploaded.path, mode: "rb")
    end
    
  end
  
end
