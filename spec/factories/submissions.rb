# frozen_string_literal: true

FactoryBot.define do
  factory :submission do
    round { create(:round) }
    candidate_id { create(:player).id }
    voter_id { create(:player).id }
  end
end
