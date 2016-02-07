require 'warbler'

Warbler::Task.new

namespace :war do
  
  task :check_production do
    if (ENV['RAILS_ENV'] != 'production')
      puts 'WARNING: this task is preferable to run in production environment'
    end
  end
  
  task :compile_assets do
    if (ENV['RAILS_ENV'] == 'production')
      renv = "RAILS_ENV=#{ENV['RAILS_ENV']}"
      relative = "RAILS_RELATIVE_URL_ROOT='/#{$WARBLER_CONFIG.jar_name}'"
      
      system "bundle exec jruby -S rake assets:precompile #{renv} #{relative}"
      system "bundle exec jruby -S rake assets:non_digested_ace #{renv}"
      abort('ERROR precompiling assets') if $?.exitstatus != 0
    else
      puts 'WARNING: Assets precompilation was skipped for non-production environment'
    end
  end
  
  task :update => ['war:check_production', 'db:migrate', 'db:seed', 'compile_assets', 'war']
  task :create => ['war:check_production', 'db:setup', 'compile_assets', 'war']

  namespace :tomcat do
    
    task :deploy => ['environment', 'war:check_production'] do
      tomcat_url = ENV['tomcat_url'] || 'http://localhost:8080'
      timeout = (ENV['timeout'] || 5.minutes).to_i
  
      user = ENV['user'] || 'local_admin'
      password = ENV['password'] || 'local_admin'
      if (!ENV['user'] || !ENV['password'])
        puts "WARNING: 'user' and 'password' parameters are not specified, default values '#{user}' and '#{password}' are used"      
      end
      
      war_url = ENV['war_url'] || ['file://', File.join(Rails.root, $WARBLER_CONFIG.jar_name + '.war').gsub('\\', '/')].join('/')
      war_path = ENV['war_path']? "/#{ENV['war_path']}" : "/#{$WARBLER_CONFIG.jar_name}"
      
      puts "Deploying WAR '#{war_url}' to '#{tomcat_url}#{war_path}'"
      request_uri = URI("#{tomcat_url}/manager/text/deploy")
      response = Net::HTTP.start(request_uri.host, request_uri.port) do |http|
        if tomcat_url.include?('localhost') # deploy locally by GET and 'war' parameter
          request_uri.query = URI.encode_www_form(
            path: war_path, 
            war: war_url,
            update: true)
          request = Net::HTTP::Get.new request_uri.request_uri
        else # deploy remotely by PUT uploading 'war' file
          request_uri.query = URI.encode_www_form(
            path: war_path,
            update: true
          )
          request = Net::HTTP::Put.new(request_uri.request_uri)
          request.body = open(war_url) { |f| f.read }
        end
        
        request.basic_auth user, password
        http.read_timeout = timeout
        
        http.request request
      end
      
      if response.is_a?(Net::HTTPSuccess)
        puts response.body
      else
        abort("ERROR: #{response}")
      end
    end
    
  end

end