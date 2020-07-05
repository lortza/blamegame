# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :game, inverse_of: :players
  has_many :submissions, foreign_key: :nominee_id, dependent: :destroy, inverse_of: :player
  has_many :submissions, foreign_key: :nominator_id, dependent: :destroy, inverse_of: :player

  validates :name, :game_id, presence: true

  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :name, uniqueness: { scope: :game_id,
                                 message: 'This name is already taken by another player. Please enter another.' }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
end
