Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  # products
  root 'products#index'
  resources :products, except: [:index]
  get '/search', to: 'products#search'

  # like
  namespace :api do
    resources :products, only: [] do
      member { post :like }
    end
  end
end
