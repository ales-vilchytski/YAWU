module Util

  class << self
    
    # Creates string representation of request which is formatted 
    # almost like original HTTP-request, except that all headers 
    # are included in upper "case underscore" style with HTTP_ prefix 
    #
    # @request [ActionDispatch::Request, #read]
    # @return [String]
    def pretty_request_str(request)
      r = request.env
      str = "#{r['REQUEST_METHOD']} #{r['REQUEST_URI']} #{r['HTTP_VERSION']}"
      r.each do |header|
        if (header[0].starts_with?('HTTP_') && header[0] != 'HTTP_VERSION')
          str << "#{$/}#{header[0]}: #{header[1]}"
        end
      end
      str << "#{$/}#{request.raw_post}"
      return str
    end
    
  end
  
end