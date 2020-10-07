FactoryBot.define do
  factory :deck do
    sequence(:name) { |n| "deck_#{n}" }
    user { nil }
  end
end
