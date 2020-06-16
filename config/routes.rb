# frozen_string_literal: true

Rails.application.routes.draw do
  root 'games#index'

  # Skip registrations for now so no new users can sign up.
  devise_for :users, skip: [:registrations]

  # Allow users to sign up and automatically populate categories and post types
  # devise_for :users, controllers: { registrations: 'registrations' }

  resources :games do
    resources :players, only: [:index, :new, :create]
    resources :rounds, only: [:show] do
      resources :submissions, only: [:new, :create, :show]
    end
  end
  resources :questions
end
