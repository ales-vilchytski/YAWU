module Xml
  
  class EscapeController < EditorController
    protect_from_forgery with: :null_session
    
    def editor
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def escape
      respond_to do |format|
        format.json { render json: { result: Xml::Escape.new(params['input']).escape } }
      end
    end
    
  end
  
end