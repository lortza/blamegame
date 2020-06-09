# frozen_string_literal: true

Rails.application.routes.draw do
  root 'posts#index'

  # Skip registrations for now so no new users can sign up.
  devise_for :users, skip: [:registrations]

  # Allow users to sign up and automatically populate categories and post types
  # devise_for :users, controllers: { registrations: 'registrations' }

  resources :post_types, only: [:index, :new, :show, :create, :edit, :update, :destroy]
  resources :posts, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :categories, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :raise_prep, only: [:index]

  get '/word_cloud', to: 'reports#word_cloud'
  get '/new_years_eve', to: 'reports#new_years_eve'
end
