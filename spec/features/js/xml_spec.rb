require 'spec_helper'

feature "JSON to XML converting" do
  include Features::Concerns::Editors
  
  before do
    visit '/js/json_xml'
  end
  
  scenario "Editor for XML can be navigated through menu", js: true do
    visit '/'
    visit_by_menu(t('application.js.label'), t('application.js.json_xml'))

    expect(body).to have_text(t('js.json_xml.editor.input'))
    expect(body).to have_text(t('js.json_xml.editor.output'))
  end
  
  scenario "User can convert JSON to XML with defaults as pretty", js: true do
    fill_in_editor(t('js.json_xml.editor.input'), with: sample_input)
    
    click_button(t('js.json_xml.editor.form_submit.label'))
    
    editor_value_should_eq(expected_output('pretty'), t('js.json_xml.editor.output'))
  end
  
  scenario "User can convert JSON to XML and get it in one line", js: true do
    fill_in_editor(t('js.json_xml.editor.input'), with: sample_input)
    select(t('js.json_xml.editor.mode.one_line'), from: t('js.json_xml.editor.mode.label'))
    
    click_button(t('js.json_xml.editor.form_submit.label'))
    
    editor_value_should_eq(expected_output('one_line'), t('js.json_xml.editor.output'))
  end
    
  def sample_input
    %Q{{
  "some": {
    "simple": {
      "json": "with text"
    }
  }
}}
  end
  
  def expected_output(mode)
    return case mode
    when 'one_line'
%Q{<?xml version="1.0" encoding="UTF-8"?><json><some><simple><json>with text</json></simple></some></json>}
    when 'pretty'
%Q{<?xml version="1.0" encoding="UTF-8"?>
<json>
  <some>
    <simple>
      <json>with text</json>
    </simple>
  </some>
</json>
}
    else 
      raise 'unsupported mode'
    end
  end
  
end