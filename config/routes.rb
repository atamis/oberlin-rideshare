Rails.application.routes.draw do
  get "listings/search"
  resources :listings do
    resources :ride_requests do
      get '/accept', to: "ride_requests#accept", as: :accept
      get '/reject', to: "ride_requests#reject", as: :reject

      #resources :messages
      match 'messages/:id' => 'messages#index', via: :get, as: :message
      match 'messages/' => 'messages#create',  via: :post
      match 'messages/:id' => 'messages#destroy', via: :delete
    end
  end
  root to: 'visitors#index'
  devise_for :users
  resources :users
end
