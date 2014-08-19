require 'spec_helper'

feature "XSD validating" do
  include Features::Concerns::Editors
  include Features::Concerns::Uploads
  
  before do
    visit '/xml/xsd'
  end
  
  scenario "User can go to XSD validator through menu", js: true do
    visit '/'
    visit_by_menu(t('application.xml.label'), t('application.xml.xsd'))

    expect(body).to have_text(t 'xml.xsd.editor.xml')
    expect(body).to have_text(t 'xml.xsd.editor.xsd')
    expect(body).to have_text(t 'xml.xsd.editor.output')
  end
  
  scenario "User can validate XML with inline XSD", js: true do
    fill_in_editor(t('xml.xsd.editor.xml'), with: TestFile['xml/catalog.xml'].text)
    fill_in_editor(t('xml.xsd.editor.xsd'), with: TestFile['xml/catalog.xsd'].text)
    
    click_button(t 'xml.xsd.editor.form_submit.label')
    
    editor_value_should_eq(expected_output[:valid], t('xml.xsd.editor.output'))
  end
  
  scenario "User see error if inline XSD is invalid", js: true do
    fill_in_editor(t('xml.xsd.editor.xml'), with: TestFile['xml/catalog.xml'].text)
    fill_in_editor(t('xml.xsd.editor.xsd'), with: '<xsd/>')
    
    click_button(t 'xml.xsd.editor.form_submit.label')
    
    expect(error_pane).to have_text(expected_output[:invalid_xsd])
  end
  
  scenario "User can validate XML with uploaded XSD file", js: true do
    fill_in_editor(t('xml.xsd.editor.xml'), with: TestFile['xml/catalog.xml'].text)
    
    click_button(t 'xml.xsd.editor.xsd_file')
    
    test_xsd = TestFile['xml/catalog.xsd']
    
    upload_file(t('concerns.uploads.form.button'), test_xsd.path)
    upload_status_should_contain(t('concerns.uploads.form.success'), t('concerns.uploads.form.button'))
    
    select(test_xsd.name, from: t('xml.xsd.editor.file')) 
    
    click_button(t 'xml.xsd.editor.form_submit.label')

    editor_value_should_eq(expected_output[:valid], t('xml.xsd.editor.output'))
  end
  
  scenario "User can't upload non-XML file" do
    click_button(t 'xml.xsd.editor.xsd_file')
    
    # forbidden filename
    upload_file(t('concerns.uploads.form.button'), TestFile['xml/catalog.xslt'].path)
        
    upload_status_should_contain(t('concerns.uploads.form.error'), t('concerns.uploads.form.button'))
    upload_status_should_contain(invalid_file[:name], t('concerns.uploads.form.button'))
    
    # forbidden conten-type
    upload_file(t('concerns.uploads.form.button'), TestFile['xml/non-xml.xml'].path)
    
    upload_status_should_contain(t('concerns.uploads.form.error'), t('concerns.uploads.form.button'))
    upload_status_should_contain(invalid_file[:content_type], t('concerns.uploads.form.button'))
  end
  
  def expected_output()
    return {
      valid: t('xml.xsd.valid'),
      invalid_xsd: 'Could not parse document',
    }
  end
  
end