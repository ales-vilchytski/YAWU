require 'spec_helper'

feature "XML to JSON converting" do
  include Features::Concerns::Editors
  
  before do
    visit '/xml/json'
  end
  
  scenario "User can go to JSON converter through menu", js: true do
    visit '/'
    visit_by_menu(t('application.xml.label'), t('application.xml.json'))
    
    expect(body).to have_text(t 'xml.json.editor.input')
    expect(body).to have_text(t 'xml.json.editor.output')
  end
  
  scenario "User can convert XML to JSON with defaults as pretty", js: true do
    fill_in_editor(t('xml.json.editor.input'), with: sample_input)
    
    click_button(t 'xml.json.editor.form_submit.label')
    
    editor_value_should_eq(expected_output('pretty'), t('xml.json.editor.output'))
  end
  
  scenario "User can convert XML to JSON and get it in one line", js: true do
    fill_in_editor(t('xml.json.editor.input'), with: sample_input)
    select(t('xml.json.editor.mode.one_line'), from: t('xml.json.editor.mode.label'))
    
    click_button(t 'xml.json.editor.form_submit.label')
    
    editor_value_should_eq(expected_output('one_line'), t('xml.json.editor.output'))
  end
    
  def sample_input
    %Q{<?xml version='1.0' encoding='utf-8'?>
      <some>
        <simple>
          <xml>with text</xml>
        </simple>
        <and attributes='can appear'>
            <too/>
        </and>
      </some>
      }
  end
  
  def expected_output(mode)
    return case mode
    when 'one_line'
%Q{{"some":{"simple":{"xml":"with text"},"and":{"attributes":"can appear","too":null}}}}
    when 'pretty'
%Q{{
  "some": {
    "simple": {
      "xml": "with text"
    },
    "and": {
      "attributes": "can appear",
      "too": null
    }
  }
}}
    else 
      raise 'unsupported mode'
    end
  end
  
end