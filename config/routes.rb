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

  root 'pages#landing'

  match '/welcome', to: 'pages#landing', via: 'get'

  get '/shift_down/:id', to: 'reviews#shift_down'
  get '/shift_up/:id', to: 'reviews#shift_up'

  get '/pricings', to: 'pricings#index'
end
