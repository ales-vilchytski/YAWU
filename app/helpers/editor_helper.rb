module EditorHelper
  
  def get_sample_xml(name)
    File.read( File.join( Rails.root, 'samples', 'xml', name) )
  end
  
  def settings_text_field_tag(opts)
    opts = {
      name: nil,
      label: nil,
      default: '', 
      placeholder: '', 
      tab_allowed: false }.merge(opts)
     
    content_tag(:div, { 'class' => 'form-group'}, nil, false) do 
      concat label_tag(opts[:name], opts[:label], 'class' => 'col-md-3 control-label')
      
      input = content_tag(:div, { 'class' => 'col-md-9' }, nil, false) do
        html_opts = { 
          'class' => 'form-control', 
          'placeholder' => opts[:placeholder], 
        }
        if (opts[:tab_allowed])
          html_opts.merge!({ 'data-input' => 'tab-allowed' })
        end
        
        concat text_field_tag(opts[:name], opts[:default], html_opts);
      end
      concat input
    end       
  end
  
  def settings_text_field_tags(settings)
    settings.each do |setting|
      concat settings_text_field_tag(setting)
    end
  end
  
  def submit_form_tag(opts, html_opts = nil)
    action = opts[:action]
    button_txt = opts[:name] ||= t('.form_submit.label')
    html_opts = { 
      'data' => { disable_with: t('.form_submit.disable') }, 
      'class' => 'btn btn-default separated' 
    }.merge(html_opts ||= {})
    
    form_tag( { action: action }, method: 'post', remote: true, data: { type: 'json', editor: 'submit' }) do
      button_tag(button_txt, html_opts)
    end
      
  end
  
end