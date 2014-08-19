require 'spec_helper'

feature "Welcome page" do
  include Features::Common
    
  before do
    visit "/"
  end
  
  scenario "User go to root page and see welcome message", js: true do
    expect(body).to have_text(I18n.t 'welcome.hello')
  end
  
  scenario "User can use root page link", js: true do
    link = find_link(I18n.t 'label')
    link.visible?.should be_true 
    
    link.click
    expect(body).to have_text(I18n.t 'welcome.hello')
  end
  
end
