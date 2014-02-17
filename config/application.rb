require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, :production or :assets.
Bundler.require(:default, :assets, Rails.env)

# Add all folder to load path for application, deployed by warbler
%w[.].each do |folder|
  path = File.expand_path( "../../#{ folder }", __FILE__ )
  $LOAD_PATH.unshift( path ) unless $LOAD_PATH.include?( path )
end

module YAWU
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
    
    config.assets.enabled = true
    config.assets.initialize_on_precompile = false
    
    config.assets.precompile += %w( editor.js editor.css )
    
  end
end
