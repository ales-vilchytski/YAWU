require 'warbler'

Warbler::Task.new

namespace :war do
  
  task :all => ['assets:precompile', 'war']

end