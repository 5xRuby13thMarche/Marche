Rails.application.routes.draw do
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
  }

  # users' orders
  get '/user/orders', to: 'users#show_orders', as: :user_order

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
    delete '/carts/delete_all_items', to: 'carts#destroy_items'
  end

  # carts
  post '/cart', to: 'carts#create'
  get '/cart', to: 'carts#index'
  delete '/cart/:id', to: 'carts#destroy', as: :cart_destroy
  get '/checkout', to: 'carts#checkout'
  
  # categories
  resources :categories

  #藍新付款路徑
  post '/orders', to: 'orders#create'
  get "/orders/:id",to: "orders#show", as: :order_show 
  post "/orders/notify",to: "orders#notify"   #接收藍新post回來的頁面

end
