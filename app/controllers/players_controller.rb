# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_game, only: %i[index create]

  def index
    @players = @game.players
  end

  def new
    @player = Player.new
    cookies.delete(:player_id)
  end

  def create
    @player = Player.new(name: player_params[:name], game_id: @game&.id)

    if @player.save
      cookies[:player_id] = { value: @player.id, expires: 1.day.from_now }
      redirect_to game_players_url(@game)
    else
      render :new
    end
  end

  private

  def set_game
    @game = if params[:game_id].present?
              Game.find_by(id: params[:game_id]&.upcase)
            else
              Game.find_by(code: player_params[:game_code]&.upcase)
            end
  end

  def player_params
    params.require(:player).permit(:game_id, :name, :game_code)
  end
end
