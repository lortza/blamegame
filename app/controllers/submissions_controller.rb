# frozen_string_literal: true

class SubmissionsController < ApplicationController
  before_action :set_submission, only: %i[show destroy]

  def index
    @submissions = current_user.submissions.paginate(page: params[:page], per_page: 30)
  end

  def new
    @submission = Submission.new
  end

  def show
  end

  def create
    @submission = current_user.submissions.new(submission_params)

    if @submission.save
      @submission.generate_rounds
      redirect_to @submission
    else
      render :new
    end
  end



  private

  def set_submission
    @submission = current_user.submissions.find(params[:id])
  end

  def submission_params
    params.require(:submission).permit(:user_id,
                                 players_attributes: [:id, :name, :_destroy])
  end
end
