# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  game_id    :bigint           not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Player < ApplicationRecord
  belongs_to :game, inverse_of: :players

  # rubocop:disable Rails/InverseOf
  has_many :submissions, foreign_key: :candidate_id, dependent: :destroy
  has_many :submissions, foreign_key: :voter_id, dependent: :destroy
  # rubocop:enable Rails/InverseOf

  validates :name, :game_id, presence: true

  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :name, uniqueness: { scope: :game_id,
                                 message: 'This name is already taken by another player. Please enter another.' }
  # rubocop:enable Rails/UniqueValidationWithoutIndex

  def votes
    winning_rounds = game.rounds.select { |round| round.winner == self }
    winning_rounds.length
  end
end
