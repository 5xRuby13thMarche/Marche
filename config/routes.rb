Rails.application.routes.draw do
  # User
  devise_for :users, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations',
  }
  get '/users/liked_products', to: 'users#show_like', as: :show_like # 收藏商品

  # 商品 （含買家、賣家）
  root 'products#index'
  resources :products do
    resources :comments, shallow: true, only: [:create, :update, :edit, :destroy] # comment
  end
  get '/search', to: 'products#search'
  
  # 商店
  resources :shops do
    resources :products, only: [:index]
    member do
      get :order
    end
    collection do 
      get :products
    end
  end
  
  # 父分類搜尋商品
  resources :categories, only: [:show]

  resources :sale_infos, only: [:edit, :update]

  # 訂單
  resources :orders, only: [:index, :new, :create, :show] do
    collection do
      post :notify # 接收藍新導回來的資料
    end
    member do 
      get :paid # 付款完導到的頁面
    end
  end

  # 購物車 cart
  resources :carts, only: [:index] # 購物車首頁

  # 購物車商品 cart_products
  resources :cart_products, only: [:destroy] # 刪除購物車內的一項商品

  # API 路徑---------------------------------------------
  namespace :api do
    # 收藏、喜歡功能
    resources :products, only: [] do
      member do
        post :like 
        post :unlike 
      end
    end

    #order_products
    resources :order_products, only: [:update]

    #category 新增商品找分類
    resources :categories, only: [:show]

    # cart_product 商品加到購物車
    resources :cart_products, only: [:create, :update] do
      collection do
        delete :delete_all
      end
    end

  end
end
