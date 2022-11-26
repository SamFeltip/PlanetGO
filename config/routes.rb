Rails.application.routes.draw do
  # get 'users/index'
  devise_for :users
  resources :users, :reviews

  resources :reviews do
    member do
      put 'like', to: 'reviews#like'
      put 'unlike', to: 'reviews#unlike'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # match '/users',   to: 'users#index',   via: 'get'

  # run ajax when go_up or go_down button is pressed

  get "/go_down/:id", to: "pages#go_down"
  get "/go_up/:id", to: "pages#go_up"

  # Defines the root path route ("/")
  # match '/users',   to: 'users#index',   via: 'get'
  match '/welcome',     to: 'pages#landing',       via: 'get'
  # Defines the root path route ("/")
  root "pages#landing"

end
