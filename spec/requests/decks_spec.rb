# frozen_string_literal: true

RSpec.describe 'Decks' do
  describe 'Public access to decks' do
    let(:user) { create(:user) }
    let(:deck) { create(:deck, user: user) }

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
    let(:user) { create(:user) }
    let(:deck) { create(:deck, user: user) }

    before :each do
      deck
      sign_in(user)
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
    end

    it 'renders decks#create' do
      starting_count = Deck.count
      deck_attributes = build(:deck).attributes
      post decks_path(deck, deck: deck_attributes)

      expect(Deck.count).to eq(starting_count + 1)
    end

    it 'renders decks#update' do
      new_name = 'different name'
      patch deck_path(deck, deck: { name: new_name })

      expect(response).to redirect_to decks_url
    end
  end

  xdescribe "Authenticated access to others' decks" do
    let(:user) { create(:user) }
    let(:deck) { create(:deck, user: user) }

    before :each do
      deck
      sign_in(user)
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
    end

    it 'renders decks#create' do
      starting_count = Deck.count
      deck_attributes = build(:deck).attributes
      post decks_path(deck, deck: deck_attributes)

      expect(Deck.count).to eq(starting_count + 1)
    end

    it 'renders decks#update' do
      new_name = 'different name'
      patch deck_path(deck, deck: { name: new_name })

      expect(response).to redirect_to decks_url(deck)
    end
  end
end
