Rails.application.routes.draw do
  # get 'users/index'
  match '/users/new', to: redirect('/404.html'), via: 'get' # No ability to create users without devise
  devise_for :users, :controllers => {:registrations_controller => "registrations_controller"}
  resources :users, only: [:index, :show, :create, :edit, :destroy]
  resources :reviews
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # match '/users',   to: 'users#index',   via: 'get'
  # Defines the root path route ("/")
  # match '/users',   to: 'users#index',   via: 'get'
  match '/welcome',     to: 'pages#landing',       via: 'get'
  # Defines the root path route ("/")
  root "pages#landing"
end
