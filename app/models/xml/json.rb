module Xml
  class Json
    attr_accessor :settings
    
    def initialize(opts = nil)
      @settings = {
        mode: 'pretty',
      }.merge(opts || {})
    end
    
    def xml_to_json(xml)
      doc = Nokogiri::XML.parse(xml)
      hash = Hash.from_xml(doc.to_xml(settings))
      
      case settings[:mode]
      when 'pretty'
        JSON.pretty_generate(hash)
      when 'one_line'
        hash.to_json
      else
        raise 'unsupported output mode'
      end
    end
        
  end
end