# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_game, only: %i[index create]

  def index
    raise Pundit::NotAuthorizedError unless valid_player_present?(@game)

    @players = @game.players
  end

  def new
    cookies.delete(:player_id)
    @player = Player.new
  end

  def new_with_code
    cookies.delete(:player_id)
    game = Game.find_by(code: params[:game_code])

    if game.present? && !game.active?
      @player = Player.new(game: game)
    else
      redirect_to join_game_path
      return
    end

    render :new
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def create
    raise Pundit::NotAuthorizedError unless @game.present?

    if @game.active? || @game.expired?
      redirect_to game_in_progress_url(@game)
      nil
    else
      @player = Player.new(name: player_params[:name], game_id: @game&.id)
      if @player.save
        cookies[:player_id] = { value: @player.id, expires: 1.day.from_now }
        cookies[:game_id] = { value: @game.id, expires: 1.day.from_now }

        GameChannel.broadcast_to @game,
                                 game_code: @game.code,
                                 player_name: @player.name,
                                 game_activated: @game.active?

        redirect_to game_players_url(@game)
      else
        render :new
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def set_game
    @game = if params[:game_id].present?
              Game.find_by(id: params[:game_id]&.upcase)
            elsif player_params[:game_id].present?
              Game.find(player_params[:game_id])
            else
              Game.find_by(code: player_params[:game_code]&.upcase)
            end
  end

  def player_params
    params.require(:player).permit(:game_id, :name, :game_code)
  end
end
