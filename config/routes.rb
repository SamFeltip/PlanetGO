Rails.application.routes.draw do
  # No ability to create users without devise
  match '/users/new', to: redirect('/404.html'), via: 'get'
  devise_for :users
  
  resources :users, :reviews, :metrics, :faqs, :register_interests

  resources :pricings, only: [] do
    resources :register_interests, only: [:index, :new, :create, :destroy]
  end

  resources :reviews do
    member do
      put 'like', to: 'reviews#like'
      put 'unlike', to: 'reviews#unlike'
    end
  end

  resources :faqs do
    member do
      put 'like', to: 'faqs#like'
      put 'unlike', to: 'faqs#unlike'
    end
  end

  root "pages#landing"

  match '/welcome', to: 'pages#landing', via: 'get'


  get "/go_down/:id", to: "pages#go_down"
  get "/go_up/:id", to: "pages#go_up"



  get '/pricings', to: 'pricings#index'

  # match 'users/sign_up?email' => redirect('/users/sign_up?{%email}')

end
