require "monban/constraints/signed_in"
require "monban/constraints/signed_out"

Rails.application.routes.draw do

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create] do
    member do
      get :confirm_email
    end
  end

  constraints Monban::Constraints::SignedIn.new do
    root "home#dashboard", as: 'dashboard'
  end

  constraints Monban::Constraints::SignedOut.new do
    root "home#welcome"
  end

  resources :articles do
    #resources :comments
    get :manage

    post :add_sentence_section
    member do
      post :create_comment

      get :next_comments
      put :re_sort
      delete :delete_all_sections
      get :export_sentences
    end

    post :import

    # manageable
    put 'show_new_form/:display_type', to: 'articles#show_new_form', as: 'show_new_form', on: :collection
    put 'cancel_new_form/:display_type', to: 'articles#cancel_new_form', as: 'cancel_new_form', on: :collection

    put 'show_import_form/:display_type', to: 'articles#show_import_form', as: 'show_import_form'
    put 'cancel_import_form/:display_type', to: 'articles#cancel_import_form', as: 'cancel_import_form'

    put 'show_edit_form/:display_type', to: 'articles#show_edit_form', as: 'show_edit_form'
    put 'cancel_edit_form/:display_type', to: 'articles#cancel_edit_form', as: 'cancel_edit_form'
  end

  resources :sentences do
    get :manage
    get :show_manage_cell
    get :show_tokenize_cell

    put :untokenize
    put :remove_last_token
    put :retranslate

    post 'add_token/:word_id', to: 'sentences#add_token', as: 'add_token'

    # manageable
    put 'show_new_form/:display_type', to: 'sentences#show_new_form', as: 'show_new_form', on: :collection
    put 'cancel_new_form/:display_type', to: 'sentences#cancel_new_form', as: 'cancel_new_form', on: :collection
    put 'show_edit_form/:display_type', to: 'sentences#show_edit_form', as: 'show_edit_form'
    put 'cancel_edit_form/:display_type', to: 'sentences#cancel_edit_form', as: 'cancel_edit_form'
  end

  resources :snippets do
    get :manage
    put 'show_new_form/:display_type', to: 'snippets#show_new_form', as: 'show_new_form', on: :collection
    put 'cancel_new_form/:display_type', to: 'snippets#cancel_new_form', as: 'cancel_new_form', on: :collection
    put 'show_edit_form/:display_type', to: 'snippets#show_edit_form', as: 'show_edit_form'
    put 'cancel_edit_form/:display_type', to: 'snippets#cancel_edit_form', as: 'cancel_edit_form'
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

    # manageable
    put 'show_new_form/:display_type', to: 'words#show_new_form', as: 'show_new_form', on: :collection
    put 'cancel_new_form/:display_type', to: 'words#cancel_new_form', as: 'cancel_new_form', on: :collection
    put 'show_edit_form/:display_type', to: 'words#show_edit_form', as: 'show_edit_form'
    put 'cancel_edit_form/:display_type', to: 'words#cancel_edit_form', as: 'cancel_edit_form'
  end

  resources :sections do
    post :set_start_time
    post :set_end_time
    post :set_section_offsets
    put 'show_new_form/:display_type', to: 'sections#show_new_form', as: 'show_new_form', on: :collection
    put 'cancel_new_form/:display_type', to: 'sections#cancel_new_form', as: 'cancel_new_form', on: :collection
    put 'show_edit_form/:display_type', to: 'sections#show_edit_form', as: 'show_edit_form'
    put 'cancel_edit_form/:display_type', to: 'sections#cancel_edit_form', as: 'cancel_edit_form'

    put 'move_up'
    put 'move_down'
  end

  resources :photos, only: [:show, :index, :create, :update, :destroy] do
    get :manage
    put 'show_new_form/:display_type', to: 'photos#show_new_form', as: 'show_new_form', on: :collection
    put 'cancel_new_form/:display_type', to: 'photos#cancel_new_form', as: 'cancel_new_form', on: :collection
    put 'show_edit_form/:display_type', to: 'photos#show_edit_form', as: 'show_edit_form'
    put 'cancel_edit_form/:display_type', to: 'photos#cancel_edit_form', as: 'cancel_edit_form'
  end

  resources :iframes, only: [:show, :index, :create, :update, :destroy] do
    get :manage
    put 'show_new_form/:display_type', to: 'iframes#show_new_form', as: 'show_new_form', on: :collection
    put 'cancel_new_form/:display_type', to: 'iframes#cancel_new_form', as: 'cancel_new_form', on: :collection
    put 'show_edit_form/:display_type', to: 'iframes#show_edit_form', as: 'show_edit_form'
    put 'cancel_edit_form/:display_type', to: 'iframes#cancel_edit_form', as: 'cancel_edit_form'
  end

  resources :sources, only: [:show, :index, :create, :update, :destroy] do
    get :manage
    put 'show_new_form/:display_type', to: 'sources#show_new_form', as: 'show_new_form', on: :collection
    put 'cancel_new_form/:display_type', to: 'sources#cancel_new_form', as: 'cancel_new_form', on: :collection
    put 'show_edit_form/:display_type', to: 'sources#show_edit_form', as: 'show_edit_form'
    put 'cancel_edit_form/:display_type', to: 'sources#cancel_edit_form', as: 'cancel_edit_form'
  end

  resources :tags, only: [:show, :index, :create, :update, :destroy] do
    get :manage
    put 'show_new_form/:display_type', to: 'tags#show_new_form', as: 'show_new_form', on: :collection
    put 'cancel_new_form/:display_type', to: 'tags#cancel_new_form', as: 'cancel_new_form', on: :collection
    put 'show_edit_form/:display_type', to: 'tags#show_edit_form', as: 'show_edit_form'
    put 'cancel_edit_form/:display_type', to: 'tags#cancel_edit_form', as: 'cancel_edit_form'
  end

  resources :categories, only: [:show, :index, :create, :update, :destroy] do
    get :manage
    put 'show_new_form/:display_type', to: 'categories#show_new_form', as: 'show_new_form', on: :collection
    put 'cancel_new_form/:display_type', to: 'categories#cancel_new_form', as: 'cancel_new_form', on: :collection
    put 'show_edit_form/:display_type', to: 'categories#show_edit_form', as: 'show_edit_form'
    put 'cancel_edit_form/:display_type', to: 'categories#cancel_edit_form', as: 'cancel_edit_form'
  end

  get 'dictionary/find' => 'words#find'

  resources :taggable do
    post 'tag/:taggable_type', to: 'taggables#tag', as: 'tag'
    post 'untag/:taggable_type/:tagging_id', to: 'taggables#untag', as: 'untag'
  end


  resources :translations do
    member do
      put :upvote
      put :downvote
      put :unvote
    end
  end

  resources :posts do
    get :manage
    member do
      post :create_attachment
    end
    delete 'delete_attachment/:attachment_id', to: 'posts#delete_attachment', as: 'delete_attachment'
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
