# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Questions', type: :request do
  describe 'Public access to questions' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before :each do
      question
    end

    it 'denies access to questions#index' do
      get questions_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to questions#new' do
      get new_question_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to questions#edit' do
      get edit_question_path(question.id)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to questions#create' do
      question_attributes = build(:question).attributes

      expect {
        post questions_path(question_attributes)
      }.to_not change(Question, :count)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to questions#update' do
      patch question_path(question, question: question.attributes)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to questions#destroy' do
      delete question_path(question)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'Authenticated access to questions' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    before :each do
      question
      sign_in(user)
    end

    it 'renders questions#new' do
      get new_question_path

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end

    it 'renders questions#edit' do
      get edit_question_path(question.id)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end

    it 'renders questions#create' do
      starting_count = Question.count
      question_attributes = build(:question).attributes
      post questions_path(question: question_attributes)

      expect(Question.count).to eq(starting_count + 1)
    end

    it 'renders questions#update' do
      new_name = 'different name'
      patch question_path(question, question: { name: new_name })

      expect(response).to redirect_to questions_url
    end

    it 'renders questions#destroy' do
      delete question_path(question)

      expect(response).to redirect_to(questions_url)
      expect(response.body).to include(questions_url)
    end
  end
end
