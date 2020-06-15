# frozen_string_literal: true

FactoryBot.define do
  factory :submission do
    round
    nominee_id { create(:player).id }
    nominator_id { create(:player).id }
  end
end
