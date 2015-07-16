class JS::PrettyController < EditorController
  
  # GET /js/pretty
  def editor
    
    respond_to do |format|
      format.html { render :editor }
    end
  end

  # POST /js/pretty/prettify
  def prettify
    opts = {}
    if (params[:indent_num].present?)
      opts[:indent_num] = params[:indent_num].to_i
    end

    result = execute_for_json do |r|
      r[:result] = JS::Pretty.new(opts).prettify(params[:input])
    end

    respond_to do |format|
      format.json { render :json => result }
    end
  end

end
