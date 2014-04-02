require 'spec_helper'

feature "XSD validating" do
  include Features::Common
  include Features::Ace
  
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
  
  scenario "User can validate XML with defaults", js: true do
    fill_in_editor(t('xml.xsd.editor.xml'), with: sample_input[:xml])
    fill_in_editor(t('xml.xsd.editor.xsd'), with: sample_input[:xsd])
    
    click_button(t 'xml.xsd.editor.form_submit.label')
    
    editor_value_should_eq(expected_output, t('xml.xsd.editor.output'))
  end
  
  scenario "User see error if XSD is invalid", js: true do
    fill_in_editor(t('xml.xsd.editor.xml'), with: sample_input[:xml])
    fill_in_editor(t('xml.xsd.editor.xsd'), with: '<xsd/>')
    
    click_button(t 'xml.xsd.editor.form_submit.label')
    
    expect(error_pane).to have_text('Could not parse document')
  end
    
  def sample_input
    return {
      xml: %Q{<?xml version='1.0' encoding='utf-8'?>
<catalog>
  <cd>
    <title>asd</title>
    <artist>qwe</artist>
  </cd>
</catalog>
      },
      xsd: %Q{<?xml version="1.0"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"> 
  <xs:element name='catalog'>
    <xs:complexType>
      <xs:sequence minOccurs="1" maxOccurs="unbounded">
        <xs:element name='cd' type='CD' />
      </xs:sequence>
    </xs:complexType>
  </xs:element>
  <xs:complexType name="CD">
    <xs:sequence>
      <xs:element name="title" type="xs:string" />
      <xs:element name="artist" type="xs:string" />
    </xs:sequence>
  </xs:complexType>     
</xs:schema>}
    }
  end
  
  def expected_output()
    t('xml.xsd.valid')
  end
  
end