class Text::Base64Controller < EditorController
  
  include Uploads::Uploadable
  upload_class Uploads::Text::Base64File
  
  # GET /text/base64
  def editor
    @files = Uploads::Text::Base64File.all
    
    respond_to do |format|
      format.html { render :editor }
    end
  end

  # POST /text/base64/encode_or_decode
  def encode_or_decode
  
    result = execute_for_json do |r|
      input = if params[:mode].include? 'file'
        Uploads::Text::Base64File.find(params[:file]).read_binary
      else
        params[:input]
      end
      
      r[:result] = if params[:mode].include? 'encode'
        Text::Base64.new.encode(input)
      else
        Text::Base64.new.decode(input)
      end
    end
    
    respond_to do |format|
      format.json { render :json => result }
    end
  end

end
