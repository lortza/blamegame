class Player < ApplicationRecord
  belongs_to :game, inverse_of: :players
  has_many :rounds, foreign_key: :winner_id, dependent: :destroy

  validates :name, presence: true
end
