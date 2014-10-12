require 'spec_helper'

feature "Text Base64 feature" do
  include Features::Concerns::Editors
  
  include Features::Concerns::Uploads
  
  before do
    visit '/text/base64'
  end
  
  scenario "Editor for Base64 can be navigated through menu", js: true do
    visit '/'
    visit_by_menu(t('application.text.label'), t('application.text.base64'))

    expect(body).to have_text(t('text.base64.editor.input'))
    expect(body).to have_text(t('text.base64.editor.output'))
  end
  
  scenario "Encode base 64 from file input", js: true do    
    upload_file(t('concerns.uploads.form.button'), TestFile['text/base64.decoded'].path)
    upload_status_should_contain(t('concerns.uploads.form.success'), t('concerns.uploads.form.button'))
    sleep(1)
    select(TestFile['text/base64.decoded'].name, from: t('text.base64.editor.file')) 
    click_button(t('text.base64.editor.form_submit.label_encode_file'))

    editor_value_should_eq(TestFile['text/base64.encoded'].text, t('text.base64.editor.output'))
  end
  
  scenario "Decode base 64 from file input", js: true do
    upload_file(t('concerns.uploads.form.button'), TestFile['text/base64.encoded'].path)
    upload_status_should_contain(t('concerns.uploads.form.success'), t('concerns.uploads.form.button'))
    sleep(1)
    select(TestFile['text/base64.encoded'].name, from: t('text.base64.editor.file')) 
    click_button(t('text.base64.editor.form_submit.label_decode_file'))

    editor_value_should_eq(TestFile['text/base64.decoded'].text.gsub(/\r?\n/, "\r\n"), t('text.base64.editor.output'))
  end
  
  scenario "Encode base 64 from text input", js: true do
    fill_in_editor(t('text.base64.editor.input'), with: TestFile['text/base64.decoded'].text)
    
    click_button(t('text.base64.editor.form_submit.label_encode_txt'))
    
    editor_value_should_eq(TestFile['text/base64.encoded'].text, t('text.base64.editor.output'))
  end

  scenario "Decode base 64 from text input", js: true do
    fill_in_editor(t('text.base64.editor.input'), with: TestFile['text/base64.encoded'].text)
    
    click_button(t('text.base64.editor.form_submit.label_decode_txt'))
    
    editor_value_should_eq(TestFile['text/base64.decoded'].text.gsub(/\r?\n/, "\r\n"), t('text.base64.editor.output'))
  end
  
end