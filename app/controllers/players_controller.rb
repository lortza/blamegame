# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_game, only: %i[index new create]

  def index
    @players = @game.players
  end

  def new
    @player = @game.players.new
  end

  def create
    @player = @game.players.new(player_params)

    if @player.save
      redirect_to game_players_url(@game)
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
