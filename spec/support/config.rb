require 'database_cleaner'
require 'capybara/rspec'
require 'fileutils'

FIREFOX_PATH = ENV['firefox_path']
FIREFOX_PROFILE = ENV['firefox_profile']
PAUSE = ENV['pause']
  
# Check usage of IPv4 only for Java 6.
# If use IPv6 or both then selenium-webdriver from 2.27.0 up to 2.42.0 won't work 
# (only in Java 6, Java 7 works great). It hangs finding free port due to error 
# binding to IPv6 loopback (in method Selenium::Webdriver::PortProber.free?)
if (java.lang.System.getProperty('java.version').start_with?('1.6.0'))
  raise 'Set JAVA_OPTS to include "-Djava.net.preferIPv4Stack=true" or use Java 7' if java.lang.System.getProperty('java.net.preferIPv4Stack') != 'true'
end

# Set up database cleaner for Selenium
DatabaseCleaner.strategy = :truncation

module MonkeyPatch
  module DatabaseCleaner
    module DerbyTruncationAdapter
      def truncate_table(table_name)
        ActiveRecord::Base.transaction do
          execute("TRUNCATE TABLE #{quote_table_name(table_name)}")
        end
      end
    end
  end
end
ActiveRecord::ConnectionAdapters::JdbcAdapter.class_eval { include MonkeyPatch::DatabaseCleaner::DerbyTruncationAdapter }


RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.after :all do
    DatabaseCleaner.clean
  end
  
  Capybara.default_wait_time = 5.seconds

  if (FIREFOX_PATH) # else if firefox not specified then webdriver use instance from program files
    Capybara.register_driver :selenium do |app|
      require 'selenium/webdriver'
      Selenium::WebDriver::Firefox::Binary.path = FIREFOX_PATH
      Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => FIREFOX_PROFILE)
    end
  end
  
  Capybara.default_driver = :selenium
  
  # Uncomment next lines to run against deployed app. Not usual case, but still
  #
  # Capybara.run_server = false
  # Capybara.app_host = 'http://localhost:8080/yawu'
    
  config.after :each, type: 'feature' do
    # Optional delay for features
    # see https://blog.codecentric.de/en/2013/08/cucumber-capybara-poltergeist/
    # 
    # Example: PAUSE=1 bundle exec rspec
    sleep(ENV['PAUSE'] || 0).to_i
    
    if example.exception && example.metadata[:js]
      meta = example.metadata
      filename = File.basename(meta[:file_path])
      line_number = meta[:line_number]
      path = "#{Rails.root.join("tmp")}/rspec/files"
      FileUtils.mkpath(path)
      file = "#{path}/FAILED-#{filename}-#{line_number}"
            
      page.save_screenshot(file + ".png")
      page.save_page(file + ".html")
    end
  end
end
