# frozen_string_literal: true

Rails.application.routes.draw do
  resources :proposed_events

  resources :events, except: %i[new show] do
    patch :like, on: :member
  end

  resources :outings do
    member do
      get 'set_details'
      post 'send_invites'
    end
    post :send_invites, on: :member
  end

  patch 'events/:id/approval/:approved', to: 'events#approval', as: :approval_event

  resources :events
  resources :participants
  resources :outings

  # No ability to create users without devise
  get '/users/new', to: redirect('/404.html')
  devise_for :users

  resources :users, :metrics, :register_interests

  resources :users do
    member do
      put 'lock', to: 'users#lock'
      put 'unlock', to: 'users#unlock'
      put 'suspend', to: 'users#suspend'
      put 'reinstate', to: 'users#reinstate'
    end
  end

  resources :pricings, only: [] do
    resources :register_interests, only: %i[index new create destroy]
  end

  root 'pages#landing'

  get '/welcome', to: 'pages#landing'
  get '/myaccount', to: 'pages#account'

  get '/pricings', to: 'pricings#index'
end
