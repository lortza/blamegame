Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'players#new'

  mount ActionCable.server => '/cable'

  # Skip registrations for now so no new users can sign up.
  devise_for :users, skip: [:registrations]

  # Allow users to sign up and automatically populate categories and post types
  # devise_for :users, controllers: { registrations: 'registrations' }

  resources :players, only: [:new, :create]
  get 'play', to: 'players#new', as: 'join_game'
  get 'play/:game_code', to: 'players#new_with_code', as: 'join_game_with_code'
  post 'play', to: 'games#players_ready', as: 'players_ready'

  resources :games do
    get 'in_progress', to: 'games#game_in_progress', as: 'in_progress'
    resources :players, only: [:index]
    resources :rounds, only: [:show] do
      resources :submissions, only: [:new, :create]
    end
  end

  resources :decks, only: [:index, :new, :create, :edit, :update] do
    resources :questions, only: [:index, :new, :create, :edit, :update]
  end
end
