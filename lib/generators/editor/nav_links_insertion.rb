module NavLinksInsertion
  
  def do_add_nav_link(menu_group)
    nav_link_file = File.join(Rails.root, 'app/views/layouts/_navbar_links.html.haml')
    current_nav_link = File.new(nav_link_file, 'rb:utf-8').read
    
    menu_guard = Regexp.escape '%a.dropdown-toggle{"data-toggle" => "dropdown", href: "#"}'
    menu_item_guard = Regexp.escape "= t('application.#{menu_group}.label')"
    insert_guard = { after: /\s*#{menu_guard}\s*#{menu_item_guard}\r?\n\s*%b.caret\s*%ul.dropdown\-menu\r?\n/ }
    
    link_markup = %Q{      %li\n        =link_to t('application.#{i18n_path}'), #{action_path}\n}
    
    if current_nav_link.match(insert_guard[:after]).nil? # no menu group
      insert_guard = { after: /#{Regexp.escape '%ul.nav.navbar-nav'}\r?\n/ }
      
      link_markup = %Q{  %li.dropdown
    %a.dropdown-toggle{"data-toggle" => "dropdown", href: "#"}
      = t('application.#{menu_group}.label')
      %b.caret
    %ul.dropdown-menu
#{link_markup}
}
    end
    
    inject_into_file nav_link_file, link_markup, insert_guard
  end
    
end