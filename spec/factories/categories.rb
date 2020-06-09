# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    user_id         { create(:user).id }
    sequence(:name) { |n| "category#{n}" }
  end
end
