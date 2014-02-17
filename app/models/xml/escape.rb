module Xml
  class Escape
    
    attr_accessor :xml_input
    
    def initialize(xml_input)
      @xml_input = xml_input
    end
    
    def escape
      ERB::Util.html_escape(@xml_input)
    end
    
  end
end