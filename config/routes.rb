require "monban/constraints/signed_in"
require "monban/constraints/signed_out"

Rails.application.routes.draw do
  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]

  constraints Monban::Constraints::SignedIn.new do
    root "home#dashboard", as: 'dashboard'
  end

  constraints Monban::Constraints::SignedOut.new do
    root "home#welcome"
  end

  # namespace :admin do

  #   resources :sources
  #   resources :categories
  #   resources :tags#, only: [:index]

  #   resources :articles do
  #     post 'add_sentence', on: :member
  #     resources :sentences
  #   end

  #   resources :sentences do
  #     post 'untokenize', on: :member
  #     post 'add_token', on: :member
  #   end

  #   resources :comments#, only: [:destroy]
  #   resources :translations
  #   resources :tokens
  #   resources :words

  # end

  resources :articles do
    resources :comments
    post 'update_word_status'

    member do
      post :create_comment
      get :next_comments
    end
  end


  resources :sentences, only: [:show, :index] do
    resources :translations, only: [:create]
    get "copy_text"
    post 'update_word_status'
  end


  resources :words, only: [:index, :show] do
    post 'search', on: :collection
    post 'search_by_definition', on: :collection
    post 'update_word_status'
  end

  get 'dictionary/find' => 'words#find'

  resources :tags, only: [:index, :show]

  resources :translations do
    member do
      put "upvote"
      put "downvote"
      put "unvote"
    end
  end


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
