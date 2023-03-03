# frozen_string_literal: true

Rails.application.routes.draw do
  resources :proposed_events
  resources :events
  resources :participants
  resources :outings
  # No ability to create users without devise
  match '/users/new', to: redirect('/404.html'), via: 'get'
  devise_for :users

  resources :users, :reviews, :metrics, :faqs, :register_interests

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
