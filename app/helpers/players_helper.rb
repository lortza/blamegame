# frozen_string_literal: true

module PlayersHelper
  def players_minus_nominator(game, nominator)
    game.players.where.not(id: nominator.id)
  end
end
