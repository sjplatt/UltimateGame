Rails.application.routes.draw do
  root 'main#index'
  #post 'get_game' => 'main#get_game'
  get 'get_game' => 'main#get_game'
  post '/ajax/get_prices' => 'main#get_prices_ajax'
  post '/ajax/get_images' => 'main#get_images_ajax'
  post '/ajax/get_videos' => 'main#get_videos_ajax'
  post '/ajax/get_extra_info' => 'main#get_extra_info_ajax'
  post '/ajax/get_reddit' => 'main#get_reddit_ajax'
  post '/ajax/get_search_results' => 'main#get_search_results_ajax'
  post '/ajax/send_suggestion' => 'main#send_suggestion'

  resources :games, only: :index do
    collection do
      get :autocomplete
    end
  end

  resources :dlcs, only: :index do
    collection do
      get :autocomplete
    end
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
