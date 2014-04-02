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
    fill_in_editor(t('xml.xslt.editor.xml'), with: sample_input[:xml])
    fill_in_editor(t('xml.xslt.editor.xslt'), with: sample_input[:xslt])
    
    click_button(t 'xml.xslt.editor.form_submit.label')
    
    editor_value_should_eq(expected_output, t('xml.xslt.editor.output'))
  end
  
  scenario "User see error if XSLT is invalid", js: true do
    fill_in_editor(t('xml.xslt.editor.xml'), with: sample_input[:xml])
    fill_in_editor(t('xml.xslt.editor.xslt'), with: '')
    
    click_button(t 'xml.xslt.editor.form_submit.label')
        
    editor_value_should_eq('', t('xml.xslt.editor.output'))
    expect(error_pane).to have_text('could not parse xslt stylesheet')   
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
      xslt: %Q{<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">                 
  <xsl:template match="/">
    <html>
    <body>
    <h2>My CD Collection</h2>
      <table border="1">
        <tr bgcolor="#9acd32">
          <th style="text-align:left">Title</th>
          <th style="text-align:left">Artist</th>
        </tr>
        <xsl:for-each select="catalog/cd">
        <tr>
          <td><xsl:value-of select="title"/></td>
          <td><xsl:value-of select="artist"/></td>
        </tr>
        </xsl:for-each>
      </table>
    </body>
    </html>
  </xsl:template>
</xsl:stylesheet>}
    }
  end
  
  def expected_output()
%Q{<?xml version="1.0"?>
<html>
    <body>
        <h2>My CD Collection</h2>
        <table border="1">
            <tr bgcolor="#9acd32">
                <th style="text-align:left">Title</th>
                <th style="text-align:left">Artist</th>
            </tr>
            <tr>
                <td>asd</td>
                <td>qwe</td>
            </tr>
        </table>
    </body>
</html>
}
  end
  
end