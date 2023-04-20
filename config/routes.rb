Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'products#index'
  resources :products ,except: [:index]
  get '/search', to: 'products#search'
end
