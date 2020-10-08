# frozen_string_literal: true

# == Schema Information
#
# Table name: decks
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_decks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Deck < ApplicationRecord
  belongs_to :user
  has_many :questions
  has_many :game_decks, dependent: :destroy
  has_many :games, through: :game_decks

  validates :name, presence: true

  DEFAULT_DECK_NAMES = [
    'Official 1',
    'Official 2'
  ]

  def self.default_decks
    where(name: DEFAULT_DECK_NAMES).order(:name)
  end

  def default?
    DEFAULT_DECK_NAMES.include?(name)
  end
end
