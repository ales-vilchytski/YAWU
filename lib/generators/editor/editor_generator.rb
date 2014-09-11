class EditorGenerator < Rails::Generators::NamedBase
  # Generator is mostly like rails generator 'controller'
  # Code copied and modified from here:
  # https://github.com/rails/rails/blob/v4.0.2/railties/lib/rails/generators/rails/controller/controller_generator.rb
  
  source_root File.expand_path('../templates', __FILE__)
  
  argument :actions, type: :array, default: [], banner: "action action"
  
  check_class_collision suffix: "Controller"
  
  def create_controller_files
    template 'controller.tt', File.join('app/controllers', class_path, "#{file_name}_controller.rb")
  end
  
  def create_view_files
    template 'view.tt', File.join('app/views', class_path, singular_name, "editor.html.haml")
  end
  
  def add_routes
    current_routes = File.new(File.join(Rails.root, 'config/routes.rb'), 'rb:utf-8').read

    namespace_re_format = %q{^\  *namespace\s+\:?[\'\"]?%s[\'\"]?\s+do\r?\n}
    
    ns_indexes = []
    if class_path.length > 0
      last_cp_i = 0
      class_path.each_with_index do |ns_part, cp_i|
        if (i = current_routes.index(/#{namespace_re_format % ns_part}/, ns_indexes.last || 0))
          ns_indexes << i
          last_cp_i = cp_i
        else
          break
        end
      end
      i = ns_indexes.last
      if i.present?
        ns_indexes << (i + current_routes[i..-1].slice(/#{namespace_re_format % class_path[last_cp_i]}/).length - 1)
      else
        ns_indexes = [ 'no_namespaces_present' ]
      end
    end
    
    # ns_indexes contains first and last index of some of namespace parts occurences
    # ns_index.length equals level of nesting + 1
    existing_namespaces_count = ns_indexes.length - 1
    needed_namespaces_count = class_path.length
    existing_nesting_level = existing_namespaces_count + 1
    needed_nesting_level = needed_namespaces_count + 1
    ns_begin_index = ns_indexes.first
    ns_end_index = ns_indexes.last
    
    
    insert_guard = if existing_namespaces_count > 0
      { after: current_routes[ns_begin_index..ns_end_index] }
    else
      { before: /\ \ namespace :xml do\r?\n/ }
    end
    
    tool_route = "" <<
      "tool('#{file_name}'" + 
      ((actions.present?) ? (", [ '#{actions.join '\', \''}' ]") : ('')) + 
      ")\n\n"
    tool_route = indent(tool_route, needed_nesting_level * 2)
    
    if (needed_namespaces_count > 0 && needed_namespaces_count > existing_namespaces_count) # we need to create namespaces
      namespace_decorator = lambda do |namespaces_txt, rest_of_class_path, i|
        if (rest_of_class_path.empty?)
          namespaces_txt
        else
          indent_val = (existing_nesting_level + i) * 2
          
          "" <<
            indent("namespace :#{rest_of_class_path.first} do\n", indent_val) +
            namespace_decorator.call(namespaces_txt, rest_of_class_path.slice(1..-1), i + 1) +
            indent("end\n\n", indent_val)
        end
      end
      
      rest_of_cp = class_path.slice(-(needed_namespaces_count - existing_namespaces_count), needed_namespaces_count)
      tool_route = namespace_decorator.call(tool_route, rest_of_cp, 0)
    end
        
    inject_into_file 'config/routes.rb', insert_guard do
      tool_route
    end
  end
  
end
