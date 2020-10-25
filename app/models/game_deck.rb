# frozen_string_literal: true

# == Schema Information
#
# Table name: game_decks
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deck_id    :bigint           not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_game_decks_on_deck_id  (deck_id)
#  index_game_decks_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (deck_id => decks.id)
#  fk_rails_...  (game_id => games.id)
#
class GameDeck < ApplicationRecord
  belongs_to :game
  belongs_to :deck
end
