[ 'nav_links_insertion.rb' ].each do |file|
  require File.expand_path("../#{file}", __FILE__)
end

class EditorGenerator < Rails::Generators::NamedBase
  # Generator is like rails generator 'controller'
  # Code copied and modified from here:
  # https://github.com/rails/rails/blob/v4.0.2/railties/lib/rails/generators/rails/controller/controller_generator.rb
  
  include NavLinksInsertion
  
  source_root File.expand_path('../templates', __FILE__)
  
  argument :actions, type: :array, default: [], banner: "action action"
  
  def initialize(*args)
    super
    if actions.empty? || only_upload?
      actions.unshift singular_name
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
    inject_with_namespace(
      path: 'config/routes.rb',
      class_path: class_path,
      namespace_re_format: %q{^\  *namespace\s+\:?[\'\"]?%s[\'\"]?\s+do\r?\n},
      if_not_insert_guard: { before: /\ \ namespace :xml do\r?\n/ },
      namespace_begin: "namespace :%s do\n",
      text: "" <<
        "tool('#{singular_name}'" + 
        ((actions.present?) ? (", [ '#{actions.join '\', \''}' ]") : ('')) + 
        ")\n\n",
      namespace_end: "end\n\n"
    )
  end
  
  def add_nav_links
    if class_path.length > 0
      do_add_nav_link(class_path.first)
    else
      do_add_nav_link("other")
    end
  end
  
  def add_i18n_keys
    # application keys
    cp = class_path.length > 0 ? class_path : ["other"]
    inject_opts = {
      path: 'config/locales/en.yml',
      class_path: ['application'] + cp,
      namespace_re_format: " *%s:\r?\n",
      if_not_insert_guard: { after: /application:\r?\n/ },
      namespace_begin: "%s:\n",
      namespace_end: "" 
    }
     
    inject_with_namespace(inject_opts.merge(
      text: "label: #{cp.last.camelize}\n"
    ))
    inject_with_namespace(inject_opts.merge(
      text: "#{singular_name}: #{singular_name.camelize} label\n"
    ))
       
    # tool keys          
    dir_path = File.join('config/locales/', cp.join("/"))
    FileUtils.mkpath(dir_path)
    
    file_path = File.join(dir_path, "en.yml")
    if (!File.exists?(file_path))
      create_file(file_path, "en:\n  ")
    end
        
    inject_with_namespace(
      path: file_path,
      class_path: cp + [singular_name, 'editor'],
      namespace_re_format: " *%s:\r?\n",
      if_not_insert_guard: { after: /en:\r?\n/ },
      namespace_begin: "%s:\n",
      text: %Q{input: Input
output: Output
form_submit:
  label: Submit
  disable: Processing},
      namespace_end: "\n"
    )
  end
  
  def add_specs
    template 'spec.tt', File.join('spec/features', class_path, "#{file_name}_spec.rb")
  end
  
  private
  
  def upload?
    actions.include? 'upload'
  end
  
  def only_upload?
    upload? && actions.length == 1
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
  
  def inject_with_namespace(opts)
    #path,
    #class_path, 
    #text, 
    #namespace_re_format, 
    #if_not_insert_guard, 
    #namespace_begin, 
    #namespace_end
    
    current_file = File.new(File.join(Rails.root, opts[:path]), 'rb:utf-8').read
        
    ns_indexes = []
    if opts[:class_path].length > 0
      last_cp_i = 0
      opts[:class_path].each_with_index do |ns_part, cp_i|
        if (i = current_file.index(/#{opts[:namespace_re_format] % ns_part}/, ns_indexes.last || 0))
          ns_indexes << i
          last_cp_i = cp_i
        else
          break
        end
      end
      i = ns_indexes.last
      if i.present?
        ns_indexes << (i + current_file[i..-1].slice(/#{opts[:namespace_re_format] % opts[:class_path][last_cp_i]}/).length - 1)
      else
        ns_indexes = [ 'no_namespaces_present' ]
      end
    end
    
    # ns_indexes contains first and last index of some of namespace parts occurences
    # ns_index.length equals level of nesting + 1
    existing_namespaces_count = ns_indexes.length - 1
    needed_namespaces_count = opts[:class_path].length
    existing_nesting_level = existing_namespaces_count + 1
    needed_nesting_level = needed_namespaces_count + 1
    ns_begin_index = ns_indexes.first
    ns_end_index = ns_indexes.last
    
    
    insert_guard = if existing_namespaces_count > 0
      { after: current_file[ns_begin_index..ns_end_index] }
    else
      opts[:if_not_insert_guard]
    end
        
    txt = indent(opts[:text], needed_nesting_level * 2)
    
    if (needed_namespaces_count > 0 && needed_namespaces_count > existing_namespaces_count) # we need to create namespaces
      namespace_decorator = lambda do |namespaces_txt, rest_of_class_path, nesting_level|
        if (rest_of_class_path.empty?)
          namespaces_txt
        else
          indent_val = nesting_level * 2
          
          "" <<
            indent(opts[:namespace_begin] % rest_of_class_path.first, indent_val) +
            namespace_decorator.call(namespaces_txt, rest_of_class_path.slice(1..-1), nesting_level + 1) +
            indent(opts[:namespace_end], indent_val)
        end
      end
      
      rest_of_cp = opts[:class_path].slice(-(needed_namespaces_count - existing_namespaces_count), needed_namespaces_count)
      txt = namespace_decorator.call(txt, rest_of_cp, existing_nesting_level)
    end
    
    inject_into_file opts[:path], txt, insert_guard
  end
  
end
