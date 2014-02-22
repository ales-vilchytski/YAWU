module Xml
  
  class EscapeController < EditorController
    
    def probe
      render :probe
    end
    
    def post_probe
      debug_request
      render text: "{ \"res\": \"1\" }"
    end
    
    def editor
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def escape
      debug_request
      
      respond_to do |format|
        format.json { render json: { result: Xml::Escape.new(params['input']).escape } }
      end
    end
    
  end
  
end