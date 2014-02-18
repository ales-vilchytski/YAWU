module Xml
  
  class FormatController < ::EditorController
    protect_from_forgery only: :format, with: :null_session
    
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