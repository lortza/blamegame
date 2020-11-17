# frozen_string_literal: true

class DecksController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create edit update]
  before_action :set_deck, only: %i[edit update]

  def index
    @decks = current_user.decks.all
  end

  def new
    @deck = current_user.decks.new
  end

  def edit
    authorize(@deck)
  end

  def create
    @deck = current_user.decks.new(deck_params)
    authorize(@deck)

    if @deck.save
      redirect_to deck_questions_url(@deck), notice: "#{@deck.name} Deck was created."
    else
      render :new
    end
  end

  def update
    authorize(@deck)
    if @deck.update(deck_params)
      redirect_to decks_url, notice: "#{@deck.name} Deck was updated."
    else
      render :edit
    end
  end

  private

  def set_deck
    @deck = Deck.find(params[:id])
  end

  def deck_params
    params.require(:deck).permit(:name, :user_id)
  end
end
