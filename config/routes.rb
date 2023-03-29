# frozen_string_literal: true

Rails.application.routes.draw do
  resources :categories
  resources :availabilities
  resources :proposed_events
  resources :proposed_events do
    post 'create'
  end

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
  
  resources :outings, param: :invite_token do
    resources :participants
    resource :invite_link, only: :show
  end
  resources :participants

  # No ability to create users without devise
  get '/users/new', to: redirect('/404.html')
  devise_for :users, controllers: { invitations: 'invitations', registrations: 'registrations', sessions: 'sessions' }

  resources :users, :metrics

  resources :users do
    member do
      put 'lock', to: 'users#lock'
      put 'unlock', to: 'users#unlock'
      put 'suspend', to: 'users#suspend'
      put 'reinstate', to: 'users#reinstate'
    end
  end

  resources :category_interests, only: %i[index] do
    member do
      put 'set_interest', to: 'category_interests#set_interest'
    end
  end

  root 'pages#account'

  get 'myaccount', to: 'pages#account'
  get 'home', to: 'pages#account'
  get 'welcome', to: 'pages#landing'

  get 'friends', to: 'friends#index'
  get 'friends/search', to: 'friends#search', as: 'friend_search'
  get 'friends/requests', to: 'friends#requests', as: 'friend_requests'
  post 'friends/:id/follow', to: 'friends#follow', as: 'follow'
  post 'friends/:id/unfollow', to: 'friends#unfollow', as: 'unfollow'
  post 'friends/:id/accept', to: 'friends#accept', as: 'accept'
  post 'friends/:id/decline', to: 'friends#decline', as: 'decline'
  post 'friends/:id/cancel', to: 'friends#cancel', as: 'cancel'
end
