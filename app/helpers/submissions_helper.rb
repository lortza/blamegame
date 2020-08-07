# frozen_string_literal: true

module SubmissionsHelper
  def players_minus_voter(game, voter)
    game.players.where.not(id: voter&.id)
  end
end
