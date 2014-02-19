class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :set_locale
 
  protected
  
  def set_locale
      I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
  end
  
  def debug_request
    Rails.logger.debug { "REQUEST: #{Util::pretty_request_str(request)}" }
  end
    
end
