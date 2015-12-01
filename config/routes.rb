Rails.application.routes.draw do
  get "listings/search"
  resources :listings do
    resources :ride_requests
  end
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
