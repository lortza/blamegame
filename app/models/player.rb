class Player < ApplicationRecord
  belongs_to :game, inverse_of: :players

  validates :name, presence: true
end
