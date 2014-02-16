module Xml
  class Format
    attr_accessor :input_xml
    
    def initialize(input_xml)
      @input_xml = input_xml
    end
    
    def format
      doc = Nokogiri::XML.parse(input_xml)
      doc.to_xml(indent: 4, indent_text: ' ')
    end
    
  end
end