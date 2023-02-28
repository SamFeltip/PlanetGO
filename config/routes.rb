# frozen_string_literal: true

Rails.application.routes.draw do
  # No ability to create users without devise
  get '/users/new', to: redirect('/404.html')
  devise_for :users

  resources :users, :reviews, :metrics, :register_interests

  resources :pricings, only: [] do
    resources :register_interests, only: %i[index new create destroy]
  end

  resources :reviews do
    member do
      put 'like', to: 'reviews#like'
      put 'unlike', to: 'reviews#unlike'
    end
  end

  root 'pages#landing'

  get '/welcome', to: 'pages#landing'

  get '/shift_down/:id', to: 'reviews#shift_down'
  get '/shift_up/:id', to: 'reviews#shift_up'

  get '/pricings', to: 'pricings#index'
end
