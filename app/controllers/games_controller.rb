# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game, only: %i[edit update destroy]

  def index
    @games = Game.all
  end

  def new
    @game = current_user.games.new(date: Time.zone.today)
  end

  def edit
  end

  def create
    @game = current_user.games.new(game_params)

    if @game.save
      redirect_to @game
    else
      render :new
    end
  end

  def update
    if @game.update(game_params)
      redirect_to @game
    else
      render :edit
    end
  end

  def destroy
    @game.destroy

    notice = "#{@game.date} #{@game.created_at} was successfully deleted."
    redirect_to games_url, notice: notice
  end

  private

  def set_game
    @game = current_user.games.find(params[:id])
  end

  def game_params
    params.require(:game)
          .permit(:user_id)
  end
end
