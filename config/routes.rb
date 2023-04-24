Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  # products
  root 'products#index'
  resources :products, except: [:index] do
    # comment
    resources :comments, shallow: true, only: [:create, :update, :edit, :destroy]
  end
  get '/search', to: 'products#search'

  # like
  namespace :api do
    resources :products, only: [] do
      member { post :like }
    end
  end
<<<<<<< HEAD
  
  # carts
  resources :carts
=======

>>>>>>> 2d540e8 ([WIP]Add ProductComment model. Add routes and controller for comment.)
end
