module Xml
  
  class FormatController < ::EditorController
    
    def editor      
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def format
      respond_to do |format|
        format.json { render json: { :result => Xml::Format.new(params['input']).format } }
      end
    end
    
  end
  
end