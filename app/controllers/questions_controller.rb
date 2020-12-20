# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create edit update]
  before_action :set_question, only: %i[edit update]
  before_action :set_deck, only: %i[index new create edit update]

  def index
    search_term = params[:search]
    @questions = @deck.questions.search(field: 'text', terms: search_term)
                      .order(:id)
                      .paginate(page: params[:page], per_page: 30)
  end

  def new
    @question = @deck.questions.new
  end

  def edit
    authorize(@question)
  end

  def create
    @question = @deck.questions.new(question_params)
    authorize(@question)

    if @question.save
      SuggestedQuestion.mark_as_processed(params[:suggested_question_id])
      redirect_to deck_questions_url(@deck)
    else
      render :new
    end
  end

  def update
    authorize(@question)

    if @question.update(question_params)
      redirect_to deck_questions_url(@deck)
    else
      render :edit
    end
  end

  def convert_from_suggestion
    @suggested_question = SuggestedQuestion.find(params[:suggested_question_id])
    @question = Question.new(text: @suggested_question.text)
    authorize(@question)

    render :new_from_suggestion
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def set_deck
    deck_id = params[:deck_id] || params[:question][:deck_id]
    @deck = Deck.find(deck_id)
  end

  def question_params
    params.require(:question)
          .permit(:user_id, :text, :adult_rating, :archived, :deck_id)
  end
end
