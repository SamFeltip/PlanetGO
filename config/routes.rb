Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # get 'users/index'
  devise_for :users
  resources :users

  resources :reviews
  # Defines the root path route ("/")
  root "pages#home"
end
