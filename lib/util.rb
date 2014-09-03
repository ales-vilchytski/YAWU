module Util

  class << self
    
    # Creates non-filtered string representation of request which is formatted 
    # almost like original HTTP-request, except that all headers are included 
    # with HTTP_UPPER_CASE_UNDERSCORE keys
    #
    # @param request [Rack::Request or ActionDispatch::Request]
    # @param opts [Hash] - additional options:
    #  :indent - text for line indentation, default is ''
    # @return [String]
    def pretty_request_str(request, opts = {})
      opts = {
        indent: ''
      }.merge opts
    
      r = request.env
      
      str = "#{opts[:indent]}#{r['REQUEST_METHOD']} #{r['REQUEST_URI']} #{r['HTTP_VERSION']}"
      r.each do |header|
        if (header[0].starts_with?('HTTP_') && header[0] != 'HTTP_VERSION')
          str << "#{$/}#{opts[:indent]}#{header[0]}: #{header[1]}"
        end
      end
      
      body_pos = request.body.pos
      request.body.read.lines.inject(str) { |s, line| s << "#{$/}#{opts[:indent]}#{line}"}
      request.body.pos = body_pos
      
      return str
    end
    
  end
  
end