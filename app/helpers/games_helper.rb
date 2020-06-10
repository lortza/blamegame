# frozen_string_literal: true

module GamesHelper
  def display_players(game)
    if game.players.present?
      game.players.map(&:name).join(', ')
    else
      link_to 'Add Players', edit_game_path(game)
    end
  end
end
