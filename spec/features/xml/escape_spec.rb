require 'spec_helper'

feature "XML escaping" do
  include Features::Common
  include Features::Ace
  
  before do
    visit '/xml/escape'
  end
  
  scenario "User can go to XML escape through menu", js: true do
    visit '/'
    visit_by_menu(t('application.xml.label'), t('application.xml.escape'))
    
    expect(body).to have_text(t 'xml.escape.editor.input')
    expect(body).to have_text(t 'xml.escape.editor.output')
  end
  
  scenario "User can escape XML with defaults", js: true do
    fill_in_editor(t('xml.escape.editor.input'), with: TestFile['xml/catalog.xml'].text)
    
    click_button(t 'xml.escape.editor.form_submit.label')
    
    editor_value_should_eq(
      TestFile['xml/escaped_catalog.txt'].text.gsub(/\r?\n/, "\r\n"), # may break on *nix
      t('xml.escape.editor.output'))
  end
    
end