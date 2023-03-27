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

  get 'myaccount', to: 'pages#account'
  get 'welcome', to: 'pages#landing'
  get 'pricings', to: 'pricings#index'

  get 'friends', to: 'friends#index'
  get 'friends/search', to: 'friends#search', as: 'friend_search'
  get 'friends/requests', to: 'friends#requests', as: 'friend_requests'
  post 'friends/:id/follow', to: 'friends#follow', as: 'follow'
  post 'friends/:id/unfollow', to: 'friends#unfollow', as: 'unfollow'
  post 'friends/:id/accept', to: 'friends#accept', as: 'accept'
  post 'friends/:id/decline', to: 'friends#decline', as: 'decline'
  post 'friends/:id/cancel', to: 'friends#cancel', as: 'cancel'
end
