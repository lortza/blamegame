# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_game, only: %i[index create]

  def index
    @players = @game.players
  end

  def new
    @player = Player.new
  end

  def create
    @player = @game.players.new(player_params.except(:game_code))

    if @player.save
      redirect_to game_players_url(@game)
    else
      render :new
    end
  end

  private

  def set_game
    if params[:game_id].present?
      @game = Game.find_by(id: params[:game_id])
    else
      @game = Game.find_by(code: player_params[:game_code]&.upcase)
    end
  end

  def player_params
    params.require(:player).permit(:game_id, :name, :game_code)
  end
end
