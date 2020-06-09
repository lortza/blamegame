# frozen_string_literal: true

FactoryBot.define do
  factory :post_type do
    user_id                         { create(:user).id }
    sequence(:name)                 { |n| "post type#{n}" }
    sequence(:description_template) { |n| "##template heading#{n}" }
  end
end
