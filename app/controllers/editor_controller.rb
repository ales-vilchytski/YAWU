# Base class for pages with Ace editors
# This controllers use layout with specific JS and CSS
#
# JSON interface restrictions:
#   - for errors 'error' object in response should contain:
#     @message{String}
#     @description{String}
class EditorController < ApplicationController
  protect_from_forgery with: :null_session
  wrap_parameters false #but remember to avoid to use parameters 'format' and 'action' in requests
  
  layout 'editor'
  
  protected

  # Useful method with error handling for JSON responses
  def execute_for_json(result = {}, &block)
    begin
      yield(result)
    rescue => e
      result[:error] = {
        :message => e.message,
        :description => e.backtrace[0]
      }
    end
    return result;
  end
  
end