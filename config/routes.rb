Rails.application.routes.draw do
  # get 'users/index'
  devise_for :users
  resources :users, :reviews, :interactions
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # match '/users',   to: 'users#index',   via: 'get'

  # Defines the root path route ("/")
  # match '/users',   to: 'users#index',   via: 'get'
  match '/welcome',     to: 'pages#landing',       via: 'get'
  # Defines the root path route ("/")
  root "pages#landing"

end
