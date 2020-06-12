# frozen_string_literal: true

module SubmissionsHelper
  def next_round_submission(submission)
    game = submission.round.game
    next_round_number = submission.round.number + 1
    next_round = game.rounds.find_by(number: next_round_number)
    "/games/#{game.id}/rounds/#{next_round.id}/submissions/new"
  end
end
