module Xml
  
  class EscapeController < EditorController
    
    def editor
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def escape
      result = execute_for_json do |r|
        escaper = Xml::Escape.new
        r[:result] = case params[:mode]
        when 'escape'
          escaper.escape(params['input'])
        when 'unescape'
          escaper.unescape(params['input'])
        else
          raise 'unsupported mode'
        end
      end
      
      respond_to do |format|
        format.json { render json: result }
      end
    end
    
  end
  
end