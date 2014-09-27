require 'spec_helper'

feature "XPath evaluation" do
  include Features::Concerns::Editors
  
  before do
    visit '/xml/xpath'
  end
  
  scenario "User can go to XPath through menu", js: true do
    visit '/'
    visit_by_menu(t('application.xml.label'), t('application.xml.xpath'))
    
    expect(body).to have_text(t('xml.xpath.editor.input_xml'))
    expect(body).to have_text(t('xml.xpath.editor.input_xpath'))
    expect(body).to have_text(t('xml.xpath.editor.output_xml'))
  end
  
  scenario "User can evaluate XPath with defaults", js: true do
    fill_in_editor(t('xml.xpath.editor.input_xml'), with: TestFile['xml/catalog.xml'].text)
    fill_in_editor(t('xml.xpath.editor.input_xpath'), with: TestFile['xml/catalog.xpath'].text)
    
    click_button(t('xml.xpath.editor.form_submit.label'))
    
    editor_value_should_eq(
      TestFile['xml/evaluated_catalog.xpath'].text.gsub(/\r?\n/, "\n"), # may break on *nix
      t('xml.xpath.editor.output_xml'))
  end
      
end