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
    fill_in_editor(t('xml.escape.editor.input'), with: sample_input)
    
    click_button(t 'xml.escape.editor.form_submit.label')
    
    editor_value_should_eq(expected_output, t('xml.escape.editor.output'))
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
  
  def expected_output
%Q{&lt;?xml version=&#39;1.0&#39; encoding=&#39;utf-8&#39;?&gt;
    &lt;some&gt;
      &lt;simple&gt;
        &lt;xml&gt;with text&lt;/xml&gt;
      &lt;/simple&gt;
      &lt;and attributes=&#39;can appear&#39;&gt;
          &lt;too/&gt;
      &lt;/and&gt;
    &lt;/some&gt;
    }.gsub(/\r?\n/, "\r\n")
  end
  
end