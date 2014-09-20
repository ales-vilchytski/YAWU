module I18nInsertion
  
  def do_add_i18n_keys
    add_application_i18n_keys
    add_tool_i18n_keys
  end
  
  def add_application_i18n_keys
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
      text: "#{singular_name}: #{singular_name.camelize}  label\n"
    ))
  end
  
  def add_tool_i18n_keys
    cp = class_path.length > 0 ? class_path : ["other"]
      
    dir_path = File.join('config/locales/', cp.join("/"))
    FileUtils.mkpath(dir_path)
    puts dir_path
    
    file_path = File.join(dir_path, "en.yml")
    if (!File.exists?(file_path))
      create_file(file_path, "en:\n  ")
    end
    
    inject_opts = {
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
    }
    
    inject_with_namespace(inject_opts)
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
    
    # namespace_re_format = %q{^\  *namespace\s+\:?[\'\"]?%s[\'\"]?\s+do\r?\n}
    
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
      # { before: /\ \ namespace :xml do\r?\n/ }
      opts[:if_not_insert_guard]
    end
    
    #tool_route = "" <<
    #  "tool('#{singular_name}'" + 
    #  ((actions.present?) ? (", [ '#{actions.join '\', \''}' ]") : ('')) + 
    #  ")\n\n"
    #tool_route = indent(tool_route, needed_nesting_level * 2)
    
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