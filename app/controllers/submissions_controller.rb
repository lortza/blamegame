# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :set_game, only: %i[new create show]
  before_action :set_round, only: %i[new create show]
  before_action :set_submission, only: %i[show]
  before_action :set_player, only: %i[new create]
  before_action :redirect_to_game, only: %i[new create]
  before_action :redirect_to_round, only: %i[new create]

  def new
    @submission = @round.submissions.new
  end

  def show
  end

  def create
    submission = @round.submissions.new(submission_params)
    submission.voter_id = @player.id

    if submission.save
      # RoundChannel.broadcast_to @round,
      #              voter_name: submission.voter.name,
      #              candidate_name: submission.candidate.name,
      #              round_complete: @round.complete?,
      #              winner: @round.winner&.name || "It's a Tie from the JS"


      ActionCable.server.broadcast 'round_channel',
        voter_name: submission.voter.name,
        candidate_name: submission.candidate.name,
        round_complete: @round.complete?,
        winner: @round.winner&.name || "It's a Tie from the JS"

      redirect_to game_round_url(@game, @round)
    else
      render :new
    end
  end

  private

  def set_submission
    @submission = Submission.find(params[:id])
  end

  def set_round
    @round = Round.find(params[:round_id])
  end

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_player
    @player = Player.find_by(id: cookies[:player_id].to_i)
  end

  def redirect_to_game
    set_round
    redirect_to game_url(@round.game), alert: 'Voting is closed for this game.' if @round.game.expired?
  end

  def redirect_to_round
    set_game
    set_round
    redirect_to game_round_url(@game, @round), alert: 'Voting is closed for this round.' if @round.complete?
  end

  def submission_params
    params.require(:submission).permit(:round_id, :candidate_id, :voter_id)
  end
end
