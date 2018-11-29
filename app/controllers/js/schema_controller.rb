class JS::SchemaController < EditorController
  
  # GET /js/schema
  def editor
    respond_to do |format|
      format.html { render :editor }
    end
  end

  # POST /js/schema/validate
  def validate
    result = execute_for_json do |r|
      r[:result] = JS::Schema.new.validate(params[:input], params[:schema])
    end

    respond_to do |format|
      format.json { render :json => result }
    end
  end

end
