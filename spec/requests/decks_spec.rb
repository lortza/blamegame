# frozen_string_literal: true

RSpec.describe 'Decks' do
  let(:user) { create(:user) }
  let(:deck) { create(:deck, user_id: user.id) }

  describe 'Public access to decks' do
    before :each do
      deck
    end

    it 'denies access to decks#index' do
      get decks_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to decks#new' do
      get new_deck_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to decks#edit' do
      get edit_deck_path(deck)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to decks#create' do
      deck_attributes = build(:deck).attributes

      expect {
        post decks_path(deck_attributes)
      }.to_not change(Deck, :count)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to decks#update' do
      new_name = 'different name'
      patch deck_path(deck, deck: { name: new_name })

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'Authenticated access to own decks' do
    before :each do
      deck
      sign_in user
    end

    it 'renders decks#new' do
      get new_deck_path

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end

    it 'renders decks#edit' do
      get edit_deck_path(deck)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
      expect(response.body).to include(deck.name)
    end

    it 'renders decks#create' do
      deck_attributes = build(:deck, user: user).attributes

      expect {
        post decks_path(deck: deck_attributes)
      }.to change(Deck, :count)
    end

    it 'renders decks#update' do
      new_name = 'completely different name'
      patch deck_path(deck, deck: { name: new_name })

      expect(response).to redirect_to decks_url
    end
  end

  describe "Authenticated access to another user's decks" do
    let(:other_user) { create(:user) }
    let(:others_deck) { create(:deck, user: other_user) }

    before do
      sign_in user
      others_deck
    end

    it 'denies access to decks#edit' do
      get edit_deck_path(others_deck)

      expect(response).to_not be_successful
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to decks#update' do
      new_name = 'completely different name'
      patch deck_path(others_deck, deck: { name: new_name })

      expect(response).to_not be_successful
      expect(response).to redirect_to new_user_session_path
    end
  end
end
