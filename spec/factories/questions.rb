# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    deck
    sequence(:text) { |n| "question#{n}?" }
    adult_rating { false }
    archived { false }
  end
end
