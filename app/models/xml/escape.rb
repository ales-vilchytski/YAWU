module Xml
  
  class Escape
        
    def initialize()
    end
    
    def escape(xml)
      ERB::Util.html_escape(xml)
    end
    
  end

end