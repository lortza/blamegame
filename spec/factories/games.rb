# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    user_id           { create(:user).id }
  end
end
