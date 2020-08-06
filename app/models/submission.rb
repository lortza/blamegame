# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :round
  belongs_to :candidate, class_name: 'Player'
  belongs_to :voter, class_name: 'Player'

  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :voter, uniqueness: { scope: :round_id,
                                  message: 'you only get to vote once per round' }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
end
