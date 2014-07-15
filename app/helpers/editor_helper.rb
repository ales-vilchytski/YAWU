module EditorHelper
  
  def get_sample_xml(name)
    File.read( File.join( Rails.root, 'samples', 'xml', name) )
  end
  
  def settings_radio_button_tag(opts)
    opts = {
      name: nil,
      label: nil,
      options: {},
      default: ''}.merge(opts)

    div_attrs = opts[:div_attrs] ? opts[:div_attrs].merge({
      'class' => opts[:div_attrs][:class] ? 'form-group ' + (opts[:div_attrs][:class]) : 'form-group'
    }) : {};

    content_tag(:div, div_attrs, nil, false) do
      concat label_tag(opts[:name], opts[:label], 'class' => 'col-md-4 control-label')

      options_div = content_tag(:div, { 'class' => 'col-md-8' }, nil, false) do
        opts[:options].each_pair do |key, value|
          option_div = content_tag(:div, { 'class' => 'col-md-12' }, nil, false) do
            concat radio_button_tag(opts[:name], key, opts[:default] == key, opts[:input_attrs]);
            concat value
          end
          concat option_div
        end
      end
      concat options_div
    end
  end

  def settings_select_field_tag(opts)
    opts = {
      name: nil,
      label: nil,
      default: '',
      placeholder: '',
      type: nil,
      options: [],
      tab_allowed: false,
      div_attrs: {},
      input_attrs: {}}.merge(opts)

    div_attrs = opts[:div_attrs] ? opts[:div_attrs].merge({
        'class' => opts[:div_attrs][:class] ? 'form-group ' + (opts[:div_attrs][:class]) : 'form-group'
    }) : {};

    content_tag(:div, div_attrs, nil, false) do
      concat label_tag(opts[:name], opts[:label], 'class' => 'col-md-4 control-label')

      input = content_tag(:div, { 'class' => 'col-md-8' }, nil, false) do
        input_attrs = opts[:input_attrs].merge({
            'class' => opts[:input_attrs][:class] ? 'form-control ' + opts[:input_attrs][:class] : 'form-control',
            'placeholder' => opts[:placeholder],
            'display' => opts[:display],
        });

        concat select_tag(opts[:name], options_for_select(opts[:options], opts[:default]), input_attrs);
      end
      concat input
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

  def submit_button_tag(opts = {}, html_opts = nil)
    button_txt = opts[:name] ||= t('.form_submit.label')
    html_opts = {
        'data' => { disable_with: t('.form_submit.disable') },
        'class' => 'btn btn-default separated'
    }.merge(html_opts ||= {})

    button_tag(button_txt, html_opts)
  end
  
  #======== DEPRECATED =========
  
  # @deprecated - use helper/settings_text_field instead
  def settings_text_field_tag(opts)
    opts = {
      name: nil,
      label: nil,
      default: '', 
      placeholder: '',
      class: '',
      type: nil,
      display: 'block',
      tab_allowed: false }.merge(opts)

    div_attrs = opts[:div_attrs] ? opts[:div_attrs].merge({
      'class' => opts[:div_attrs][:class] ? 'form-group ' + (opts[:div_attrs][:class]) : 'form-group'
    }) : {};

    content_tag(:div, div_attrs, nil, false) do
      concat label_tag(opts[:name], opts[:label], 'class' => 'col-md-4 control-label')
      
      input = content_tag(:div, { 'class' => 'col-md-8' }, nil, false) do
        html_opts = { 
          'class' => 'form-control', 
          'placeholder' => opts[:placeholder],
          'type' => opts[:type],
          'display' => opts[:display],
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
  
end