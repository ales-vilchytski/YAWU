class JS::JsonXmlController < EditorController
  
  # GET /js/json_xml/convert
  def editor
    
    respond_to do |format|
      format.html { render :editor }
    end
  end

  # POST /js/json_xml/convert
  def convert
    opts = {
    }.merge(nothing_if_empty_or_nil({
        mode: params[:mode]
      })
    )
    result = execute_for_json do |r|
      xmljson = Converters::XmlJson.new(opts)
      r[:result] = xmljson.json_to_xml(params[:input])
    end
    
    respond_to do |format|
      format.json { render :json => result }
    end
  end

end
