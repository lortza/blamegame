# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: %i[edit update destroy]

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

  def destroy
    @question.destroy
    notice = "#{@question.text} was successfully deleted."
    redirect_to questions_url, notice: notice
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question)
          .permit(:user_id, :text, :family_friendly)
  end
end
