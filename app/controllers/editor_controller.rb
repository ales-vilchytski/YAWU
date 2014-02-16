# Base class for pages with Ace editors
# This controllers use layout with specific JS and CSS
class EditorController < ApplicationController
  protect_from_forgery with: :null_session
  
  layout 'editor'
  
end