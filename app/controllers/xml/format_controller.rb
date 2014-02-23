module Xml
  
  class FormatController < EditorController
    
    def editor      
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def format
      opts = {
        indent: 1,
      }.merge(nil_if_empty({      
          indent_text: params[:indent_text],
          # there can be issue with internal encoding on front, by on the Ruby side
          # string is encoded properly
          encoding: params[:encoding],
        })
      );
      
      result = execute_for_json do |r|
        formatter = Xml::Format.new(opts)
        
        r[:result] = formatter.format(params[:input])
      end
      
      respond_to do |format|
        format.json { render json: result }
      end
    end
    
  end
  
end