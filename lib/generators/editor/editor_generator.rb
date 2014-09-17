[ 'routes_insertion.rb', 'nav_links_insertion.rb' ].each do |file|
  require File.expand_path("../#{file}", __FILE__)
end

class EditorGenerator < Rails::Generators::NamedBase
  # Generator is like rails generator 'controller'
  # Code copied and modified from here:
  # https://github.com/rails/rails/blob/v4.0.2/railties/lib/rails/generators/rails/controller/controller_generator.rb
  
  source_root File.expand_path('../templates', __FILE__)
  include RoutesInsertion
  include NavLinksInsertion  
  
  argument :actions, type: :array, default: [], banner: "action action"
  
  def initialize(*args)
    super
    if actions.empty?
      actions << singular_name
    end
  end
  
  def create_controller_files
    template 'controller.tt', File.join('app/controllers', class_path, "#{file_name}_controller.rb")
  end
  
  def create_view_files
    template 'view.tt', File.join('app/views', class_path, singular_name, "editor.html.haml")
  end
  
  def create_assets_javascript_files
    template 'assets_javascript.tt', File.join('app/assets/javascripts/views', "#{file_path}.js")  
  end
  
  def create_model_files
    if (upload?)
      upload_model_file = File.join('app/models/uploads', "#{upload_file_name}.rb")
      template 'upload_model.tt', upload_model_file
      
      say "Don't forget to set up whitelist of mime-types and extensions for uploads"
      say "  see #{upload_model_file}"
    end
    template 'model.tt', File.join('app/models', class_path, "#{file_name}.rb")
  end
  
  def add_routes
    do_add_routes
  end
  
  def add_nav_links
    if class_path.length > 0
      do_add_nav_link(class_path.first)
    else
      do_add_nav_link("other")
    end
  end
  
  private
  
  def upload?
    actions.include? 'upload'
  end
  
  def upload_class_name
    "#{class_name}File"
  end
  
  def upload_file_name
    upload_class_name.underscore
  end
  
  def action_path
    "#{file_path.gsub('/', '_')}_path"
  end
  
  def i18n_path
    file_path.tr "/", "."
  end
  
end
