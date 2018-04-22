require 'spec_helper'

feature "Misc Finance feature" do
  include Features::Concerns::Editors
  
  before do
    visit '/misc/finance'
  end
  
  scenario "Editor for Finance can be navigated through menu", js: true do
    visit '/'
    visit_by_menu(t('application.misc.label'), t('application.misc.finance'))

    expect(body).to have_text(t('misc.finance.editor.input'))
    expect(body).to have_text(t('misc.finance.editor.output'))
  end
  
  scenario "Some specific tests", js: true do
    pending "implement specific tests"
  end

end