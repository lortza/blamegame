Rails.application.routes.draw do
  root "landing#index"
  get 'landing/index'
  devise_for :users
  resources :messages
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
