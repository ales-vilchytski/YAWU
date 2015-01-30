module Xml

  class JsonController < EditorController
    
    def editor
      respond_to do |format|
        format.html { render :editor }
      end
    end
    
    def json
      opts = {
      }.merge(nothing_if_empty_or_nil({
          mode: params[:mode]
        })
      )
      result = execute_for_json do |r|
        xmljson = Converters::XmlJson.new(opts)
        
        r[:result] = xmljson.xml_to_json(params[:input])
      end
      
      respond_to do |format|
        format.json { render :json => result }
      end
    end
    
  end
    
end