module Xml
  
  class Xpath
        
    def initialize()
    end
    
    def evaluate(xml, xpath)
      Nokogiri::XML.parse(xml).xpath(xpath).to_xml
    end
    
  end

end