class Submission < ApplicationRecord
  belongs_to :round
  belongs_to :nominee, class_name: 'Player', optional: true
  belongs_to :nominator, class_name: 'Player', optional: true

  validates :nominator, uniqueness: { scope: :round_id,
    message: "you only get to vote once per round" }
end
