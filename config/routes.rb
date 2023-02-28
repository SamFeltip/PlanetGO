# frozen_string_literal: true

Rails.application.routes.draw do
  # No ability to create users without devise
  get '/users/new', to: redirect('/404.html')
  devise_for :users

  resources :users, :metrics, :register_interests

  resources :pricings, only: [] do
    resources :register_interests, only: %i[index new create destroy]
  end

  root 'pages#landing'

  get '/welcome', to: 'pages#landing'

  get '/pricings', to: 'pricings#index'
end
