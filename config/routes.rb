Rails.application.routes.draw do
  # get 'users/index'
  devise_for :users
  resources :users, :reviews
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # match '/users',   to: 'users#index',   via: 'get'

  # Defines the root path route ("/")
  root "pages#home"
end
