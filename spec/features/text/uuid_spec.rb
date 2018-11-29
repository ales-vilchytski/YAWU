require 'spec_helper'

feature "Text Uuid feature" do
  include Features::Concerns::Editors
  
  before do
    visit '/text/uuid'
  end
  
  scenario "Editor for Uuid can be navigated through menu", js: true do
    visit '/'
    visit_by_menu(t('application.text.label'), t('application.text.uuid'))

    expect(body).to have_text(t('text.uuid.editor.input'))
    expect(body).to have_text(t('text.uuid.editor.output'))
  end
  
  scenario "Some specific tests", js: true do
    pending "implement specific tests"
  end

end