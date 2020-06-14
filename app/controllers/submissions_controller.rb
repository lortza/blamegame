# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :set_game, only: %i[index new create show edit update destroy]
  before_action :set_round, only: %i[index new create show edit update destroy]
  before_action :set_submission, only: %i[show destroy]

  def index
    @submissions = current_user.submissions.paginate(page: params[:page], per_page: 30)
  end

  def new
    @submission = @round.submissions.new
  end

  def show
  end

  def create
    @submission = @round.submissions.new(submission_params)

    if @submission.save
      redirect_to game_round_submission_url(@game, @round, @submission)
      # redirect_to game_round_url(@game, @round)
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

  def submission_params
    params.require(:submission).permit(:round_id, :nominee_id, :nominator_id)
  end
end
