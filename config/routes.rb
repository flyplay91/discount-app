Rails.application.routes.draw do
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
# frozen_string_literal: true

namespace :app_proxy do
  root action: 'index'
  # simple routes without a specified controller will go to AppProxyController

  # more complex routes will go to controllers in the AppProxy namespace
  #   resources :reviews
  # GET /app_proxy/reviews will now be routed to
  # AppProxy::ReviewsController#index, for example
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/search_products' => 'home#search_products'
  get '/search_variants' => 'home#search_variants'
  get '/search_collections' => 'home#search_collections'
  get '/api/product' => 'api#product'
  get '/api/multi-products' => 'api#multi_products'
  get '/api/filter_options' => 'api#filter_options'
  post '/api/draft-order' => 'api#draft_order'
  post '/api/cart' => 'api#cart'

  resources :installation
  resources :rules
  resources :suppliers do
    member do
      get :status
      get :get_sub_brands
    end
  end
  resources :products do
    collection do
      get :missing
    end
  end
  resources :variants
  resources :orders
  resources :purchase_orders do
    collection do
      get :create_po
    end
    member do
      post :append_draft_order
      put :complete_draft_order
    end
  end
  resources :purchase_order_items do
    member do
      get :send_invoice
      get :download_pdf
      get :render_pdf
    end
  end
  resource :settings, only: %i(show update)
end
