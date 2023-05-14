Rails.application.routes.draw do
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
  }

  # 商品 （含買家、賣家）
  root 'products#index'
  resources :products do
    # comment
    resources :comments, shallow: true, only: [:create, :update, :edit, :destroy]
  end
  get '/search', to: 'products#search'
  get '/shops/products', to: 'products#shop_products', as: :shop_products
  
  # 商店
  resources :shops
  
  # 父分類搜尋商品
  resources :categories, only: [:show]

  # 訂單
  resources :orders, only: [:index, :new, :create, :show] do
    collection do
      post :notify # 接收藍新導回來的資料
    end
  end
  get '/orders/:id/paid', to: 'orders#paid', as: :order_paid # 付款完導到的頁面
  get '/shops/:id/order', to: 'orders#shop_order', as: :shop_order # 賣家自己的所有訂單


  # carts
  post '/cart', to: 'carts#create'
  get '/cart', to: 'carts#index'
  delete '/cart/:id', to: 'carts#destroy', as: :cart_destroy
  get '/checkout', to: 'carts#checkout'

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

  # 收藏商品
  get '/users/liked_products', to: 'users#show_like', as: :show_like


end
