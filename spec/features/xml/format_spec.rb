require 'spec_helper'

feature "XML formatting" do
  include Features::Concerns::Editor
  
  before do
    visit '/xml/format'
  end
  
  scenario "User can go to XML formatter through menu", js: true do
    visit '/'
    visit_by_menu(t('application.xml.label'), t('application.xml.format'))

    expect(body).to have_text(t 'xml.format.editor.input')
    expect(body).to have_text(t 'xml.format.editor.output')
  end
  
  scenario "User can format XML with default indentation by 2 spaces", js: true do
    fill_in_editor(t('xml.format.editor.input'), with: sample_input)
    
    click_button(t 'xml.format.editor.form_submit.label')
        
    editor_value_should_eq(expected_output(' '), t('xml.format.editor.output'))
  end
  
  scenario "User can format XML with own indentation text", js: true do
    fill_in_editor(t('xml.format.editor.input'), with: sample_input)
    fill_in(t('xml.format.editor.indent_text.label'), with: '.')
    
    click_button(t 'xml.format.editor.form_submit.label')
    
    editor_value_should_eq(expected_output('.'), t('xml.format.editor.output'))
  end
  
  def sample_input
    %Q{<?xml version='1.0' encoding='utf-8'?><non><formatted><xml>with text</xml></formatted></non>}
  end
  
  def expected_output(indent_text)
    i = indent_text
%Q{<?xml version="1.0" encoding="utf-8"?>
<non>
#{i}<formatted>
#{i}#{i}<xml>with text</xml>
#{i}</formatted>
</non>
}
  end
  
end