class DecksController < ApplicationController
  before_action :set_deck, only: [:edit, :update, :destroy]

  def index
    @decks = current_user.decks.all
  end

  def new
    @deck = current_user.decks.new
  end

  def edit
  end

  def create
    @deck = current_user.decks.new(deck_params)

    if @deck.save
      redirect_to deck_questions_url(@deck), notice: "#{@deck.name} Deck was created."
    else
      render :new
    end
  end

  def update
    if @deck.update(deck_params)
      redirect_to deck_questions_url(@deck), notice: "#{@deck.name} Deck was updated."
    else
      render :edit
    end
  end

  def destroy
    @deck.destroy
    redirect_to decks_url, notice: "#{@deck.name} Deck was deleted."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deck
      @deck = Deck.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def deck_params
      params.require(:deck).permit(:name, :user_id)
    end
end
