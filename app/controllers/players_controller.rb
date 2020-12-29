# frozen_string_literal: true

class PlayersController < ApplicationController
  before_action :set_game, only: %i[index create new_with_code]

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

    if @game.present? && !@game.active?
      @player = Player.new(game: @game)
    else
      redirect_to join_game_path
      return
    end

    render :new
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def create
    raise Pundit::NotAuthorizedError if @game.blank?

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
    @game = if game_identifiers[:id].present?
              Game.find_by(id: game_identifiers[:id])
            else
              Game.find_by(code: game_identifiers[:code])
            end
  end

  def game_identifiers
    game_id = params[:player].present? ? player_params[:game_id] : params[:game_id]
    game_code = params[:player].present? ? player_params[:game_code] : params[:game_code]

    {
      id: game_id,
      code: game_code&.upcase
    }
  end

  def player_params
    params.require(:player).permit(:game_id, :name, :game_code)
  end
end
