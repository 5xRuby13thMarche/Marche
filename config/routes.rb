Rails.application.routes.draw do
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
  }

  # products
  root 'products#index'

  resources :products do
    # comment
    resources :comments, shallow: true, only: [:create, :update, :edit, :destroy]
  end
  get '/search', to: 'products#search'

  resources :shops do 
    # get '/products', to: 'shops#'
  end


  # carts
  post '/cart', to: 'carts#create'
  get '/cart', to: 'carts#index'
  delete '/cart/:id', to: 'carts#destroy', as: :cart_destroy
  get '/checkout', to: 'carts#checkout'
  
  # categories
  resources :categories
  get '/parent_category/:id', to: 'products#category', as: :product_parent_category # 大項分類頁面

  #order
  get '/shop/:id/order', to: 'orders#shop_order', as: :shop_order

  resources :orders, only: %i[create] do
    collection do
      post :notify
    end
  end

  # post '/orders', to: 'orders#create'
  get "/orders/:id",to: "orders#show", as: :order_show 
  # users' orders
  get '/orders', to: 'orders#show_orders', as: :show_orders
  # post "/orders/notify",to: "orders#notify"   #接收藍新post回來的頁面


  # API 路徑
  namespace :api do
    # like api
    resources :products, only: [] do
      member do
        post :like 
        post :dislike 
      end
    end
    # cart_product
    post '/cart_product', to: 'cart_product#sendToCart'
  
    #category
    post '/categories', to: 'categories#assign'

    # 購物車頁面 Cart API
    post '/carts/:id/edit', to: 'carts#edit', as: :carts_edit
    delete '/carts/delete_all_items', to: 'carts#destroy_items'
  end


end
