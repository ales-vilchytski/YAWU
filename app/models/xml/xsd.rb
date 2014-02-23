module Xml
  
  class Xsd
    attr_accessor :xsd, :options
    
    def initialize(xsd, opts = nil)
      @xsd = Nokogiri::XML::Schema(xsd)
      @options = opts
    end
    
    def validate(xml)
      doc = Nokogiri::XML(xml)
      
      xsd.validate(doc)
    end
    
  end
  
end