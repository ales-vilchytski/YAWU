module Xml
  
  class Xpath
        
    def initialize()
    end
    
    def evaluate(xml, xpath)
      evaluated = Nokogiri::XML.parse(xml).xpath(xpath)
      
      result = if evaluated.is_a?(Nokogiri::XML::NodeSet)
        evaluated.to_xml
      else
        evaluated.to_s
      end
      return result
    end
    
  end

end