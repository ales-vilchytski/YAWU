require 'spec_helper'

feature "JS Pretty feature" do
  include Features::Concerns::Editors
  
  before do
    visit '/js/pretty'
  end
  
  scenario "Editor for Pretty can be navigated through menu", js: true do
    visit '/'
    visit_by_menu(t('application.js.label'), t('application.js.pretty'))

    expect(body).to have_text(t('js.pretty.editor.input'))
    expect(body).to have_text(t('js.pretty.editor.output'))
  end
  
  scenario "User can prettify JSON with defaults (2 spaces indentation)", js: true do
    fill_in_editor(t('js.pretty.editor.input'), with: sample_input)

    click_button(t('js.pretty.editor.form_submit.label'))

    editor_value_should_eq(expected_output('default'), t('js.pretty.editor.output'))
  end

  scenario "User can make oneline JSON (0 spaces indentation", js: true do
    fill_in_editor(t('js.pretty.editor.input'), with: sample_input)
    fill_in(t('js.pretty.editor.indent_num.label'), with: '0')

    click_button(t('js.pretty.editor.form_submit.label'))

    editor_value_should_eq(expected_output('oneline'), t('js.pretty.editor.output'))
  end

  scenario "User can prettify JSON width any number of spaces", js: true do
    fill_in_editor(t('js.pretty.editor.input'), with: sample_input)
    fill_in(t('js.pretty.editor.indent_num.label'), with: '4')

    click_button(t('js.pretty.editor.form_submit.label'))

    editor_value_should_eq(expected_output('pretty4'), t('js.pretty.editor.output'))
  end

  def sample_input
    %Q{{  "some": {
    "simple": { "json": "with text"
    }
  }
}}
  end

  def expected_output(mode)
    return case mode
    when 'default'
%Q{{
  "some": {
    "simple": {
      "json": "with text"
    }
  }
}}
    when 'oneline'
%Q{{"some":{"simple":{"json":"with text"}}}}
    when 'pretty4'
%Q{{
    "some": {
        "simple": {
            "json": "with text"
        }
    }
}}
    else
      raise 'unsupported mode'
    end
  end
end