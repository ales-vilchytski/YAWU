module Xml
  
  class EscapeController < EditorController
    
    def editor
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def escape
      result = execute_for_json do |r|
        r[:result] = Xml::Escape.new.escape(params['input'])
      end
      
      respond_to do |format|
        format.json { render json: result }
      end
    end
    
  end
  
end