require 'warbler'

Warbler::Task.new

namespace :war do
  
  namespace :assets do
    task :compile do
      `bundle exec jruby -S rake assets:precompilt RAILS_RELATIVE_URL_ROOT='/#{$WARBLER_CONFIG.jar_name}' RAILS_ENV=production`
    end
        
  end
  
  task :all => ['war:assets:compile', 'war']

end