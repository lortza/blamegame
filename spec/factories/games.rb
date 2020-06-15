# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    user_id           { create(:user).id }

    trait :with_3_players do
      after :create do |game|
        create_list :player, 3, game: game
      end
    end

    trait :with_2_rounds do
      after :create do |game|
        create_list :round, 2, game: game
      end
    end
  end
end
