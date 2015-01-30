module EditorHelper
    
  def get_sample(name)
    File.read( File.join( Rails.root, 'samples', name) );
  end
  
  def submit_button(opts = {})
    opts = {
      id: nil,
      text: t('.form_submit.label'),
      disable_with: t('.form_submit.disable')
    }.merge(opts)
    render('concerns/buttons/submit', opts)
  end
  
end