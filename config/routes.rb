Rails.application.routes.draw do
  resources :ride_requests
  get "listings/search"
  resources :listings
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
