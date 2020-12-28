# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create update]
  before_action :set_game, only: %i[show update players_ready]
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
    @game = current_user.games.new(
      max_rounds: Game::DEFAULT_MAX_ROUNDS,
      deck_ids: Deck.default_decks.pluck(:id)
    )
    5.times { @game.players.build }
  end

  def show
    authorize(@game)

    # Trying to get all browsers to go to the game#show when a single
    # player clicks the button. Causes infinite loop.
    # RoundChannel.broadcast_to @game.rounds.last,
    #                          game_code: @game.code,
    #                          game_over: true,
    #                          destination_url: game_url(@game)
    delete_cookies
  end

  def create
    @game = current_user.games.new(game_params)

    if @game.save
      @game.generate_rounds
      notice = "Oh SNAP! It's about to be <em>on</em>. Game #{@game.code} is ready to rock!"
      redirect_to games_url, notice: notice
    else
      render :new
    end
  end

  def update
    authorize(@game)

    if @game.update(game_params)
      redirect_to games_url
    else
      render :edit
    end
  end

  def players_ready
    @game.update(players_ready: true)
    GameChannel.broadcast_to @game,
                             game_code: @game.code,
                             player_name: 'undefined',
                             game_activated: @game.active?,
                             destination_url: new_game_round_submission_url(@game, @game.rounds.first)

    redirect_to new_game_round_submission_url(@game, @game.rounds.first)
  end

  def game_in_progress
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
                                 players_attributes: %i[id name _destroy],
                                 deck_ids: [])
  end

  def delete_cookies
    cookie_names = %i[player_id game_id]
    cookie_names.each do |name|
      cookies.delete(name)
    end
  end
end
