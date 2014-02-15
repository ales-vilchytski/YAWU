class ProbeController < EditorController
  protect_from_forgery with: :null_session
   
  layout 'editor'
  
  def get
    Rails.logger.debug("REQUEST: #{Util::pretty_request_str(request)}")
    @result = params['inp']
    respond_to do |format|
      format.html { render :index }
      format.json { render json: {:out => params['inp']} }
    end
  end
  
  def post
    Rails.logger.debug("REQUEST: #{Util::pretty_request_str(request)}")
    sleep 10
    respond_to do |format|
      format.html { redirect_to action: 'get' }
      format.json { render json: { :result => request.raw_post } }
    end
  end
end
