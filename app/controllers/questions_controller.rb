# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: %i[edit update destroy]

  def index
    @questions = Question.all.order(:id)
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

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

    notice = "#{@question.date} #{@question.created_at} was successfully deleted."
    redirect_to questions_url, notice: notice
  end

  private

  def set_question
    @question = current_user.questions.find(params[:id])
  end

  def question_params
    params.require(:question)
          .permit(:user_id)
  end
end
