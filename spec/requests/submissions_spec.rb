# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Submissions', type: :request do
  xdescribe 'Public access to submissions' do
    let(:user) { create(:user) }
    let(:game) { create(:game, user: user) }
    let(:player) { create(:player, game: game) }
    let(:round) { create(:round, game: game) }

    before :each do
      round
    end

    context 'when the round is new' do
      it 'GET new_game_round_submission_url' do
        get new_game_round_submission_url

        expect(response).to be_successful
        expect(response).to render_template(:new)
      end
      it 'a player can make a submission' do
      end

      it 'redirects to the submissions index' do
      end
    end

    context 'when the player has already submitted for this round' do
      it 'redirects to the round show page' do
      end
    end

    context 'when a game is expired' do
      it 'redirects somewhere probably' do
      end
    end



    xit 'denies access to submissions#index' do
      get submissions_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to submissions#new' do
      get new_submission_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to submissions#edit' do
      get edit_submission_path(submission.id)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to submissions#create' do
      submission_attributes = build(:submission, user: user).attributes

      expect {
        post submissions_path(submission_attributes)
      }.to_not change(Submission, :count)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to submissions#update' do
      patch submission_path(submission, submission: submission.attributes)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to submissions#destroy' do
      delete submission_path(submission)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

  xdescribe 'Authenticated access to own submissions' do
    let(:user) { create(:user) }
    let(:submission) { create(:submission, user: user) }

    before :each do
      submission
      sign_in(user)
    end

    it 'renders submissions#new' do
      get new_submission_path

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end

    it 'renders submissions#edit' do
      get edit_submission_path(submission.id)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end

    it 'renders submissions#create' do
      starting_count = Submission.count
      submission_attributes = build(:submission, user: user).attributes
      post submissions_path(submission: submission_attributes)

      expect(Submission.count).to eq(starting_count + 1)
    end

    it 'renders submissions#update' do
      new_name = 'different name'
      patch submission_path(submission, submission: { name: new_name })

      expect(response).to redirect_to submissions_url
    end

    it 'renders submissions#destroy' do
      delete submission_path(submission)

      expect(response).to redirect_to(submissions_url)
      expect(response.body).to include(submissions_url)
    end
  end

  xdescribe "Authenticated access to another user's submissions" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user2_submission) { create(:submission, user: user2) }

    before :each do
      user2_submission
      sign_in(user1)
    end

    it 'denies access to submissions#edit' do
      get edit_submission_path(user2_submission.id)

      expect(response).to_not be_successful
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_url)
    end

    it 'denies access to submissions#update' do
      new_name = 'completely different name'
      patch submission_path(user2_submission, submission: { name: new_name })

      expect(response).to_not be_successful
      expect(response).to redirect_to root_url
    end

    it 'denies access to submissions#destroy' do
      delete submission_path(user2_submission)

      expect(response).to_not be_successful
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_url
    end
  end
end
