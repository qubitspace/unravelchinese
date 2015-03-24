Rails.application.routes.draw do

  get 'home/index'

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :articles do
    resources :comments

    get 'tokenize', on: :member

  end

  resources :sentences do
    member do
      get 'tokenize'
      get 'untokenize'
    end
  end

  resources :words
  resources :tags

  get 'add_sentence', to: 'articles#add_sentence', as: :add_sentence

  get 'add_token', to: 'sentences#add_token', as: :add_token

  get 'watch_word', to: 'users#watch_word', as: :watch_word
  get 'learn_word', to: 'users#learn_word', as: :learn_word

  get 'update_status', to: 'learned_words#update_status', as: :update_learned_word_status

  # You can have the root of your site routed with "root"
  root 'home#index'

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
