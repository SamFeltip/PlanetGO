# frozen_string_literal: true

Rails.application.routes.draw do
  resources :proposed_events
  resources :events
  resources :participants
  resources :outings
  # No ability to create users without devise
  get '/users/new', to: redirect('/404.html')
  devise_for :users

  resources :users, :metrics, :register_interests

  resources :pricings, only: [] do
    resources :register_interests, only: %i[index new create destroy]
  end

  root 'pages#landing'

  match '/welcome', to: 'pages#landing', via: 'get'
  match '/myaccount', to: 'pages#account', via: 'get'

  get '/pricings', to: 'pricings#index'
end
