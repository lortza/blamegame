# frozen_string_literal: true

# == Schema Information
#
# Table name: submissions
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  candidate_id :bigint
#  round_id     :bigint           not null
#  voter_id     :bigint
#
# Indexes
#
#  index_submissions_on_candidate_id  (candidate_id)
#  index_submissions_on_round_id      (round_id)
#  index_submissions_on_voter_id      (voter_id)
#
# Foreign Keys
#
#  fk_rails_...  (candidate_id => players.id)
#  fk_rails_...  (round_id => rounds.id)
#  fk_rails_...  (voter_id => players.id)
#
class Submission < ApplicationRecord
  belongs_to :round
  belongs_to :candidate, class_name: 'Player'
  belongs_to :voter, class_name: 'Player'

  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :voter, uniqueness: { scope: :round_id,
                                  message: 'you only get to vote once per round' }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
end
