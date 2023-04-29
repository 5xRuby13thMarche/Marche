Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  # products
  root 'products#index'
  resources :products, except: [:index] do
    # comment
    resources :comments, shallow: true, only: [:create, :update, :edit, :destroy]
  end
  get '/search', to: 'products#search'

  namespace :api do
    # like
    resources :products, only: [] do
      member do
        post :like 
        post :dislike 
      end
    end
  
    #category
    post '/categories', to: 'categories#assign'
  end

  #

  # carts
  post '/cart', to: 'carts#create'
  get '/cart', to: 'carts#index'
  get '/checkout', to: 'carts#checkout'
  
  # categories
  resources :categories
  

end
