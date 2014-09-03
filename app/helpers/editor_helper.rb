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

  def submit_button(opts = {})
    opts = {
      id: nil,
      text: t('.form_submit.label'),
      disable_with: t('.form_submit.disable')
    }.merge(opts)
    render('concerns/buttons/submit', opts)
  end
  
  #======== DEPRECATED =========
  
  # @deprecated - use concerns/fields/text instead
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
end