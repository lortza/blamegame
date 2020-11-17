# frozen_string_literal: true

RSpec.describe 'Questions' do
  let(:user) { create(:user) }
  let(:deck) { create(:deck, user: user) }
  let(:question) { create(:question, deck: deck) }

  describe 'Public access to questions' do
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
  end

  describe 'Authenticated access to own questions' do
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
      get edit_deck_question_path(deck, question)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
      expect(response.body).to include(question.text)
    end

    it 'renders questions#create' do
      question_attributes = build(:question, deck: deck).attributes

      expect {
        post deck_questions_path(deck_id: deck.id, question: question_attributes)
      }.to change(Question, :count)
      expect(response).to have_http_status(302)
    end

    it 'renders questions#update' do
      new_name = 'completely different name'
      patch deck_question_path(deck, question, question: { name: new_name })

      expect(response).to have_http_status(302)
      expect(response).to redirect_to deck_questions_url
    end
  end

  describe "Authenticated access to another user's questions" do
    let(:other_user) { create(:user, admin: false) }
    let(:others_deck) { create(:deck, user: other_user) }
    let(:others_question) { create(:question, deck: others_deck) }

    before do
      sign_in(user)
      others_question
    end

    it 'denies access to questions#edit' do
      get edit_deck_question_path(others_deck, others_question)

      expect(response).to_not be_successful
      expect(response).to redirect_to root_url
    end

    it 'denies access to questions#update' do
      new_name = 'completely different name'
      patch deck_question_path(others_deck, others_question, question: { name: new_name })

      expect(response).to_not be_successful
      expect(response).to redirect_to root_url
    end
  end
end
