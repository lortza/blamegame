# frozen_string_literal: true

class RoundsController < ApplicationController
  before_action :set_round, only: %i[show edit update destroy]

  def show
    @round.set_winner
  end

  private

  def set_round
    @round = Round.find(params[:id])
  end

  def round_params
    params.require(:round)
  end
end
