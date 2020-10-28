# frozen_string_literal: true

RSpec.describe 'Questions' do
  describe 'Public access to questions' do
    let(:user) { create(:user) }
    let(:deck) { create(:deck, user: user) }
    let(:question) { create(:question, deck: deck) }

    before :each do
      question
    end

    it 'denies access to questions#index' do
      get deck_questions_path(deck)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to questions#new' do
      get new_deck_question_path(deck)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to questions#edit' do
      get edit_deck_question_path(deck, question.id)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to questions#create' do
      question_attributes = build(:question).attributes

      expect {
        post deck_questions_path(deck, question_attributes)
      }.to_not change(Question, :count)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to questions#update' do
      new_name = 'different name'
      patch deck_question_path(deck, question, question: { name: new_name })

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    # it 'denies access to questions#destroy' do
    #   delete deck_question_path(deck, question)
    #
    #   expect(response).to have_http_status(302)
    #   expect(response).to redirect_to new_user_session_path
    # end
  end

  describe 'Authenticated access to questions' do
    let(:user) { create(:user) }
    let(:deck) { create(:deck, user: user) }
    let(:question) { create(:question, deck: deck) }

    before :each do
      question
      sign_in(user)
    end

    it 'renders questions#new' do
      get new_deck_question_path(deck)

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end

    it 'renders questions#edit' do
      get edit_deck_question_path(deck, question.id)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end

    it 'renders questions#create' do
      starting_count = Question.count
      question_attributes = build(:question).attributes
      post deck_questions_path(deck, question: question_attributes)

      expect(Question.count).to eq(starting_count + 1)
    end

    it 'renders questions#update' do
      new_name = 'different name'
      patch deck_question_path(deck, question, question: { name: new_name })

      expect(response).to redirect_to deck_questions_url(deck)
    end

    # it 'renders questions#destroy' do
    #   delete deck_question_path(deck, question)
    #
    #   expect(response).to redirect_to(deck_questions_url(deck))
    #   expect(response.body).to include(deck_questions_url(deck))
    # end
  end
end
