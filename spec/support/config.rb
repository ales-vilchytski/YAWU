require 'database_cleaner'
require 'capybara/rspec'
require 'fileutils'

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