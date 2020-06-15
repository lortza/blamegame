# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game, only: %i[show edit update destroy]

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
    @game = current_user.games.new
    10.times { @game.players.build }
  end

  def show
  end

  def edit
    5.times { @game.players.build }
  end

  def create
    @game = current_user.games.new

    if @game.save
      @game.generate_rounds(params[:adult_content_permitted])
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

    notice = "Game at #{@game.date} was successfully deleted."
    redirect_to games_url, notice: notice
  end

  private

  def set_game
    @game = current_user.games.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:user_id,
                                 :players_ready,
                                 players_attributes: [:id, :name, :_destroy])
  end
end
