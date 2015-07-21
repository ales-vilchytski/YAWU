class Text::UrlCodingController < EditorController
  
  include Uploads::Uploadable
  upload_class Uploads::Text::UrlCodingFile
  
  # GET /text/url_coding
  def editor
    
    @files = Uploads::Text::UrlCodingFile.all
    
    respond_to do |format|
      format.html { render :editor }
    end
  end

  # POST /text/url_coding/encode_or_decode
  def encode_or_decode
  
    result = execute_for_json do |r|
      input = if params[:mode].include?('file')
        Uploads::Text::UrlCodingFile.find(params[:file]).read
      else
        params[:input]
      end
      
      encoding = params[:encoding]
      
      if (params[:mode].include?('encode'))
        r[:result] = Text::UrlCoding.new.encode(input, encoding)
      else
        r[:result] = Text::UrlCoding.new.decode(input, encoding)
      end
    end
  
    
    respond_to do |format|
      format.json { render :json => result }
    end
  end

end
