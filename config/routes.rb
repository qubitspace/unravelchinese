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

  resources :articles do
    #resources :comments
    get :manage
    member do
      post :create_comment
      post :create_sentence
      get :next_comments
    end
    get :manage
  end

  resources :sentences do
    get :manage
  end

  resources :words do
    put :update_status
    get :manage

    # Definitions
    post :create_definition
    put 'update_definition/:definition_id', to: 'words#update_definition', as: 'update_definition'
    delete 'delete_definition/:definition_id', to: 'words#delete_definition', as: 'delete_definition'

    get 'show_edit_definition_form/:definition_id', to: 'words#show_edit_definition_form', as: 'show_edit_definition_form'
    get 'show_manage_definition_cell/:definition_id', to: 'words#show_manage_definition_cell', as: 'show_manage_definition_cell'

  end

  get 'dictionary/find' => 'words#find'

  resources :taggable do
    post 'untag/:tagging_id', to: 'words#untag', as: 'untag'
  end

  resources :tags

  resources :translations do
    member do
      put :upvote
      put :downvote
      put :unvote
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
