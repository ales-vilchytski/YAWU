module Features
  module Common
    extend ActiveSupport::Concern
    
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
      find(:css, '#error_panel')
    end
    
    # Visit page by clicking links in navbar
    # 
    # @param *args [Vararg, #read] parts of path to page, e.g. visit_by_menu('xml', 'xsd')
    def visit_by_menu(*args)
      within navbar do
        args.each do |path|
          link = find_link(path)
          link.visible?.should be_true
          link.click
        end
      end
    end

    def wait_until(opts = {})
      value = nil
      begin
        Timeout.timeout(opts[:timeout] || Capybara.default_wait_time) do
          sleep(0.1) until value = yield
        end
      rescue Timeout::Error
      end
      return value
    end
        
  end
end