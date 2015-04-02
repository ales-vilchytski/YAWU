require 'spec_helper'

feature "Text UrlCoding feature" do
  include Features::Concerns::Editors
  include Features::Concerns::Uploads
  
  before do
    visit '/text/url_coding'
  end
  
  scenario "Editor for UrlCoding can be navigated through menu", js: true do
    visit '/'
    visit_by_menu(t('application.text.label'), t('application.text.url_coding'))

    expect(body).to have_text(t('text.url_coding.editor.input'))
    expect(body).to have_text(t('text.url_coding.editor.output'))
  end
  
  scenario "Encode URL from file input", js: true do    
    upload_file(t('concerns.uploads.form.button'), TestFile['text/url.decoded'].path)
    upload_status_should_contain(t('concerns.uploads.form.success'), t('concerns.uploads.form.button'))
    sleep(1)
    select(TestFile['text/url.decoded'].name, from: t('text.url_coding.editor.file')) 
    click_button(t('text.url_coding.editor.form_submit.label_encode_file'))

    editor_value_should_eq(TestFile['text/url.encoded'].text, t('text.url_coding.editor.output'))
  end
  
  scenario "Decode URL from file input", js: true do
    upload_file(t('concerns.uploads.form.button'), TestFile['text/url.encoded'].path)
    upload_status_should_contain(t('concerns.uploads.form.success'), t('concerns.uploads.form.button'))
    sleep(1)
    select(TestFile['text/url.encoded'].name, from: t('text.url_coding.editor.file')) 
    click_button(t('text.url_coding.editor.form_submit.label_decode_file'))

    editor_value_should_eq(TestFile['text/url.decoded'].text.gsub(/\r?\n/, "\r\n"), t('text.url_coding.editor.output'))
  end
  
  scenario "Encode URL from text input", js: true do
    fill_in_editor(t('text.url_coding.editor.input'), with: TestFile['text/url.decoded'].text)
    
    click_button(t('text.url_coding.editor.form_submit.label_encode_text'))
    
    editor_value_should_eq(TestFile['text/url.encoded'].text, t('text.url_coding.editor.output'))
  end

  scenario "Decode URL from text input", js: true do
    fill_in_editor(t('text.url_coding.editor.input'), with: TestFile['text/url.encoded'].text)
    
    click_button(t('text.url_coding.editor.form_submit.label_decode_text'))
    
    editor_value_should_eq(TestFile['text/url.decoded'].text.gsub(/\r?\n/, "\r\n"), t('text.url_coding.editor.output'))
  end

end