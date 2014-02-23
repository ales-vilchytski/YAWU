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
  
  # Assigns nil for all values in hash which .empty? returns true
  #
  # @hash [Hash, #write]
  def nil_if_empty(hash)
    hash.each { |k, v| hash[k] = (v.empty?) ? (nil) : (v) }
  end
  
  # Deletes all values from hash which .empty? or .nil? returns true
  # 
  # @hash [Hash, #write]
  def nothing_if_empty_or_nil(hash) 
    hash.delete_if { |k, v| v.empty? || v.nil? }
  end
  
  # Useful method with error handling for JSON responses
  # Executes block passing hash storing results of execution, return error object
  # if any exception is raised
  #
  # @result [Hash, #write]
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