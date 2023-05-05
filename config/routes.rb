Rails.application.routes.draw do
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
 
  # products
  root 'products#index'

  resources :products do
    # comment
    resources :comments, shallow: true, only: [:create, :update, :edit, :destroy]
  end
  get '/search', to: 'products#search'
  get '/category/:id', to: 'products#category', as: :product_category

  namespace :api do
    # like
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

    # cart
    post '/carts/:id/edit', to: 'carts#edit', as: :carts_edit
  end

  # carts
  post '/cart', to: 'carts#create'
  get '/cart', to: 'carts#index'
  delete '/cart/:id', to: 'carts#destroy', as: :cart_destroy
  get '/checkout', to: 'carts#checkout'
<<<<<<< HEAD
  
  # categories
  resources :categories
=======

  post '/orders', to: 'orders#create'
    #藍新付款路徑
  get "/orders",to: "orders#index"     #購物車頁面/付款失敗頁面
  post "/orders/notify",to: "orders#notify"   #接收藍新post回來的頁面
  get "/hello/:id", to: "orders#hello", as: "hello"   #付款成功的頁面
>>>>>>> 8b268ad (fix: Fix orders routes error)

  
end
