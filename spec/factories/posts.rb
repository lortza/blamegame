# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    post_type_id           { create(:post_type).id }
    sequence(:date)        { Time.zone.today - rand(0..10) }
    sequence(:description) { |n| "Lorem ipsum dolor sit amet, consectetur do adipisicing elit, sit sed do eiusmod#{n}" }
    sequence(:with_people) { |n| "GivenBy Name#{n}" }
    sequence(:url)         { |n| "http://www.url#{n}.com" }
    bookmarked             { false }
  end
end
