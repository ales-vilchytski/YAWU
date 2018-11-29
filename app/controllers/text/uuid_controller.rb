class Text::UuidController < EditorController
  
  # GET /text/uuid
  def editor
    respond_to do |format|
      format.html { render :editor }
    end
  end

  # POST /text/uuid/generate
  def generate
    result = execute_for_json do |r|
      quantity = if params[:quantity].blank?
        1
      else
        params[:quantity].to_i
      end
      r[:result] = Text::Uuid.new.generate(quantity)
    end

    respond_to do |format|
      format.json { render :json => result }
    end
  end

end
