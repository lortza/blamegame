class Round < ApplicationRecord
  belongs_to :game
  belongs_to :question
  belongs_to :winner, class_name: 'Player', optional: true
  # has_many :submissions
end
