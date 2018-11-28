require 'spec_helper'

feature "JS Schema feature" do
  include Features::Concerns::Editors
  
  before do
    visit '/js/schema'
  end
  
  scenario "Editor for Schema can be navigated through menu", js: true do
    visit '/'
    visit_by_menu(t('application.js.label'), t('application.js.schema'))

    expect(body).to have_text(t('js.schema.editor.input'))
    expect(body).to have_text(t('js.schema.editor.output'))
  end
  
  scenario "Some specific tests", js: true do
    pending "implement specific tests"
  end

end