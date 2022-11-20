Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # get 'users/index'
  devise_for :users
  resources :users

  resources :reviews

  # match '/users',   to: 'users#index',   via: 'get'
  match '/welcome',     to: 'pages#landing',       via: 'get'
  # Defines the root path route ("/")
  root "pages#landing"

  # Defines the root path route ("/")
end
