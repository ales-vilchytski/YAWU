class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  protected
  
  def debug_request
    Rails.logger.debug("REQUEST: #{Util::pretty_request_str(request)}")
  end
  
end
