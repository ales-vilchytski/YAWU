module Features
  module Common
    
    def t(*args)
      I18n.t(*args)
    end
    
    def navbar
      find('nav')
    end
    
    def body
      all('body > div.container-fluid')[0]
    end
    
    def error_pane
      find(:css, '#error_pane')
    end
    
    def visit_by_menu(*args)
      args.each do |path|
        link = find_link(path)
        link.visible?.should be_true
        link.click
      end
    end
        
  end
end