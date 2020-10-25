# frozen_string_literal: true

module RoundsHelper
  def next_round_submission(round)
    game = round.game
    next_round_number = round.number + 1
    next_round = game.rounds.find_by(number: next_round_number)
    "/games/#{game.id}/rounds/#{next_round.id}/submissions/new"
  end

  def display_winner(segment)
    if segment.winner.present?
      segment.winner.name
    else
      "It's a tie"
    end
  end

  def hidden_class(round)
    'hidden' unless round.complete?
  end

  def display_current_round_of_total(round)
    "#{round.number} of #{round.game.total_rounds}"
  end
end
