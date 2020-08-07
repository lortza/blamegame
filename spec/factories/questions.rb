# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:text) { |n| "question#{n}?" }
    adult_rating { [true, false].sample }
  end
end
