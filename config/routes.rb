YAWU::Application.routes.draw do
  
  root 'welcome#index'
  
  # Helper defining routes for tools
  # Creates get and post methods and optional upload path
  # 
  # @name [String, #read] - path
  # @opts [Hash, #read] - additional settings. Supports:
  #                         :upload => 'action'
  def tool(name, opts = nil)
    get name => "#{name}#editor"
    post name => "#{name}##{name}"
    if (opts && opts[:upload])
      post "#{name}/upload" => "#{name}##{opts[:upload]}"
    end
  end
  
  namespace :xml do
    tool('format')
    
    tool('escape')
    
    tool('json')
 
    tool('xslt')
    
    tool('xsd', upload: 'upload')
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
