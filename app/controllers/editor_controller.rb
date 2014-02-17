# Base class for pages with Ace editors
# This controllers use layout with specific JS and CSS
class EditorController < ApplicationController
  protect_from_forgery with: :null_session
  wrap_parameters false #but remember to avoid to use parameters 'format' and 'action' in requests
  
  layout 'editor'
  
end