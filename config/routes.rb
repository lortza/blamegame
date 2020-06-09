# frozen_string_literal: true

Rails.application.routes.draw do
  # temporary root route. replace with real, non-devise route.
  devise_scope :user do
    root to: "devise/passwords#edit"
  end

  # Skip registrations for now so no new users can sign up.
  devise_for :users, skip: [:registrations]

  # Allow users to sign up and automatically populate categories and post types
  # devise_for :users, controllers: { registrations: 'registrations' }

end
