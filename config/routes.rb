Rails.application.routes.draw do
  devise_for :users
  
  # products
  root 'products#index'
  resources :products ,except: [:index]
  get '/search', to: 'products#search'
end
