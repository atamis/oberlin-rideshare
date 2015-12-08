Rails.application.routes.draw do
  get "listings/search"
  resources :listings do
    resources :ride_requests do
      get '/accept', to: "ride_requests#accept", as: :accept
      get '/reject', to: "ride_requests#reject", as: :reject
    end
  end
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
