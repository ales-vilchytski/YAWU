module Xml
  class Format
    attr_accessor :settings
    
    def initialize(opts)
      @settings = {
        indent: 4, 
        indent_text: ' ',
        encoding: nil,
      }.merge(opts || {})
    end
    
    def format(xml)
      doc = Nokogiri::XML.parse(xml)
      doc.to_xml(settings)
    end
    
  end
end