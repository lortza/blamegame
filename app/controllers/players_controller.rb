# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_game, only: %i[new create]

  def new
    @player = @game.players.new
  end

  def create
    @player = @game.players.new(player_params)

    if @player.save
      redirect_to @game
    else
      render :new
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def player_params
    params.require(:player).permit(:game_id, :name)
  end
end
