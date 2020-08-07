# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create edit update destroy]
  before_action :set_game, only: %i[show edit update destroy players_ready]
  before_action :redirect_to_play, only: %i[show]

  def index
    @current_games = current_user.games
                                 .current
                                 .order('created_at DESC')
    @past_games = current_user.games
                              .past
                              .order('created_at DESC')
                              .paginate(page: params[:page], per_page: 30)
  end

  def new
    @game = current_user.games.new(max_rounds: Game::DEFAULT_MAX_ROUNDS)
    5.times { @game.players.build }
  end

  def show
    cookies.delete(:player_id)
  end

  def edit
    # authorize(@game)

    5.times { @game.players.build }
  end

  def create
    @game = current_user.games.new(game_params)

    if @game.save
      @game.generate_rounds
      redirect_to games_url
    else
      render :new
    end
  end

  def update
    if @game.update(game_params)
      redirect_to games_url
    else
      render :edit
    end
  end

  def destroy
    @game.destroy

    cookies.delete(:player_id)
    notice = "Game at #{@game.date} was successfully deleted."
    redirect_to games_url, notice: notice
  end

  def players_ready
    @game.update(players_ready: true)
    redirect_to game_players_url(@game)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def redirect_to_play
    set_game
    redirect_to join_game_path if @game.expired? && @game.complete? && current_user.blank?
  end

  def game_params
    params.require(:game).permit(:user_id,
                                 :adult_content_permitted,
                                 :max_rounds,
                                 :players_ready,
                                 players_attributes: %i[id name _destroy])
  end
end