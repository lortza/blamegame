# frozen_string_literal: true

FactoryBot.define do
  factory :round do
    game
    question
    sequence(:number) { |n| n }
  end
end
