require 'spec_helper'

feature "XSLT transformation" do
  include Features::Common
  include Features::Ace
  
  before do
    visit '/xml/xslt'
  end
  
  scenario "User can go to XSLT through menu", js: true do
    visit '/'
    visit_by_menu(t('application.xml.label'), t('application.xml.xslt'))

    expect(body).to have_text(t 'xml.xslt.editor.xml')
    expect(body).to have_text(t 'xml.xslt.editor.xslt')
    expect(body).to have_text(t 'xml.xslt.editor.output')
  end
  
  scenario "User can run XSLT with defaults", js: true do
    fill_in_editor(t('xml.xslt.editor.xml'), with: TestFile['xml/catalog.xml'].text)
    fill_in_editor(t('xml.xslt.editor.xslt'), with: TestFile['xml/catalog.xslt'].text)
    
    click_button(t 'xml.xslt.editor.form_submit.label')
    
    editor_value_should_eq(TestFile['xml/transformed_catalog.xml'].text, t('xml.xslt.editor.output'))
  end
  
  scenario "User see error if XSLT is invalid", js: true do
    fill_in_editor(t('xml.xslt.editor.xml'), with: TestFile['xml/catalog.xml'].text)
    fill_in_editor(t('xml.xslt.editor.xslt'), with: '')
    
    click_button(t 'xml.xslt.editor.form_submit.label')
    
    editor_value_should_eq('', t('xml.xslt.editor.output'))
    expect(error_pane).to have_text('could not parse xslt stylesheet')   
  end
  
end