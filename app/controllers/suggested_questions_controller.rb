# frozen_string_literal: true

class SuggestedQuestionsController < ApplicationController
  before_action :set_suggested_question, only: [:show]

  def index
    authorize(SuggestedQuestion.last)
    @suggested_questions = SuggestedQuestion.all
  end

  def show
  end

  def new
    @suggested_question = SuggestedQuestion.new
  end

  def create
    @suggested_question = SuggestedQuestion.new(suggested_question_params)
    if @suggested_question.save
      redirect_to @suggested_question
    else
      render :new
    end
  end

  private
    def set_suggested_question
      @suggested_question = SuggestedQuestion.find(params[:id])
    end

    def suggested_question_params
      params.require(:suggested_question).permit(:text, :processed_at)
    end
end
