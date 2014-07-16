namespace :rspec do
  
  task :prepare do
    system "bundle exec jruby -S rake db:setup RAILS_ENV=test"
    abort('ERROR setting up DB') if $?.exitstatus != 0
  end
  
  task :run do
    example = ENV['example']
    args = example ? " --example #{example}" : ''
    
    system "bundle exec jruby -S rspec spec/ -r spec/support/scr_html.rb -f ScrHtml -o tmp/rspec/report.html #{args}"
    abort('ERROR running rspec') if $?.exitstatus != 0
  end
  
  task :all => ['rspec:prepare', 'rspec:run']
  
end
