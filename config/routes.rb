YAWU::Application.routes.draw do
  
  root 'welcome#index'
  
  # Helper defining routes for tools
  # Creates get and post methods and optional upload path
  # 
  # @param name [String, #read] path and action
  # @param tools [Array, #read] nested paths and actions instead of first-level action
  def tool(name, tools = [])
    get name => "#{name}#editor"
    
    if (!tools || tools.empty?)
      post name => "#{name}##{name}"
    else
      tools.each { |t| post "#{name}/#{t}" => "#{name}##{t}" }
    end
  end
  
  namespace :text do
    tool('uuid', [ 'generate' ])

    tool('url_coding', [ 'encode_or_decode', 'upload' ])

    tool('base64', [ 'encode_or_decode', 'upload' ])

  end

  namespace :js do
    tool('schema', [ 'validate' ])

    tool('pretty', [ 'prettify' ])

    tool('json_xml', [ 'convert' ])

  end

  namespace :misc do
    tool('finance', [ 'parse_string_to_table' ])

  end

  namespace :xml do
    tool('format')
    
    tool('escape')
    
    tool('json')
 
    tool('xslt')
    
    tool('xsd', ['validate', 'upload'])
    
    tool('xpath')
  end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
