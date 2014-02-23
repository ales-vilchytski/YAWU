module Xml
  
  class Xslt
    attr_accessor :xslt, :options
    
    def initialize(xslt, opts = nil)
      @xslt = Nokogiri::XSLT(xslt)
      @options = opts
    end
    
    def transform(xml)
      xslt.transform(Nokogiri::XML(xml)).to_xml( { indent: 4, indent_text: ' ' })
    end
    
  end
  
end