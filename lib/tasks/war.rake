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
      abort('ERROR precompiling assets') if $?.exitstatus != 0
    else
      puts 'WARNING: Assets precompilation was skipped for non-production environment'
    end
  end
  
  task :update => ['war:check_production', 'db:migrate', 'db:seed', 'compile_assets', 'war']
  task :create => ['war:check_production', 'db:setup', 'compile_assets', 'war']

end