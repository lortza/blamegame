# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[index new create edit update]

  before_action :set_question, only: %i[edit update]
  before_action :set_deck, only: %i[index new create edit update]

  def index
    search_term = params[:search]
    questions = search_term.present? ? Question.search(field: 'text', terms: search_term) : Question.all

    @questions = questions.order(:id)
                          .paginate(page: params[:page], per_page: 30)
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to questions_url
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to questions_url
    else
      render :edit
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question)
          .permit(:user_id, :text, :adult_rating, :archived, :deck_id)
  end
end
