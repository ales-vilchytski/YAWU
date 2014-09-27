namespace :rspec do
  
  task :prepare do
    system "bundle exec jruby -S rake db:setup RAILS_ENV=test"
    abort('ERROR setting up DB') if $?.exitstatus != 0
  end
  
  task :run do
    args = ENV['args']
    spec = ENV['spec'] || './spec'
    
    ENV['JAVA_OPTS'] = '-Xms512m -Xmx2048m -XX:PermSize=64m -XX:MaxPermSize=256m'
    # Hack for webdriver + Java 6 error when finding free port 
    # TCPServer.new raises exception when host is IPv6 loopback - then just turn off IPv6
    ENV['JAVA_OPTS'] += ' -Djava.net.preferIPv4Stack=true' if java.lang.System.getProperty('java.version').start_with? '1.6.0'
    
    system "bundle exec rspec #{spec} -r spec/support/scr_html.rb -f ScrHtml -o tmp/rspec/report.html #{args}"
    abort('ERROR running rspec') if $?.exitstatus != 0
  end
  
  task :all => ['rspec:prepare', 'rspec:run']
  
end
