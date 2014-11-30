module Xml
  
  class Escape
        
    def initialize()
    end
    
    def escape(xml)
      # Replace predefined XML entities only
      # http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references#Predefined_entities_in_XML
      replacements = {
        '"' => '&quot;',
        '&' => '&amp;',
        "'" => '&apos;',
        '<' => '&lt;',
        '>' => '&gt;',
      }
      xml.gsub(Regexp.union(replacements.keys), replacements)
    end
    
    def unescape(xml)
      doc = Nokogiri::XML.parse xml
      if doc.child
        # we can't unescape XML-document because it'll become invalid 
        raise UnexpectedDocumentError.new('unescape')
      else
        # not XML - use Nokogiri to deal with it
        Nokogiri::XML.fragment(xml).text
      end
    end
    
  end

end