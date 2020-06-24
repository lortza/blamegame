# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :round
  belongs_to :nominee, class_name: 'Player'
  belongs_to :nominator, class_name: 'Player'

  validates :nominator, uniqueness: { scope: :round_id,
                                      message: 'you only get to vote once per round' }
end
