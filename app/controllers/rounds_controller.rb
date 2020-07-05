# frozen_string_literal: true

class RoundsController < ApplicationController
  before_action :set_round, only: %i[show]
  before_action :redirect_to_game, only: %i[show]

  def show
  end

  private

  def set_round
    @round = Round.find(params[:id])
  end

  def redirect_to_game
    set_round
    redirect_to game_url(@round.game) if @round.game.expired?
  end

  def round_params
    params.require(:round)
  end
end
