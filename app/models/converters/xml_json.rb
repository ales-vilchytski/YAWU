module Converters
  class XmlJson
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
    
    def json_to_xml(json)
      hash_for_xml = JSON.parse(json)
      root = 'json'
      
      # TODO: implement array conversion as elements sequence without extra surrounding tag
      # TODO: implement xml attributes
      
      case settings[:mode]
      when 'pretty'
        hash_for_xml.to_xml(:root => root, :skip_types => true)
      when 'one_line'
        hash_for_xml.to_xml(:root => root, :skip_types => true, indent: 0)
      else
        raise 'unsupported output mode'
      end
    end

  end
end