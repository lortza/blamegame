# frozen_string_literal: true

RSpec.describe 'Games' do
  describe 'Public access to games' do
    let(:user) { create(:user) }
    let(:user_game) { create(:game, user: user) }

    before :each do
      user_game
    end

    it 'denies access to games#index' do
      get games_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to games#new' do
      get new_game_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to games#edit' do
      get edit_game_path(user_game.id)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to games#create' do
      game_attributes = build(:game, user: user).attributes

      expect {
        post games_path(game_attributes)
      }.to_not change(Game, :count)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to games#update' do
      patch game_path(user_game, game: user_game.attributes)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'denies access to games#destroy' do
      delete game_path(user_game)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'Authenticated access to own games' do
    let(:user) { create(:user) }
    let(:user_game) { create(:game, user: user) }

    before :each do
      user_game
      sign_in(user)
    end

    it 'renders games#new' do
      get new_game_path

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end

    it 'renders games#edit' do
      get edit_game_path(user_game.id)

      expect(response).to be_successful
      expect(response).to render_template(:edit)
    end

    it 'renders games#create' do
      starting_count = Game.count
      game_attributes = build(:game, user: user).attributes
      post games_path(game: game_attributes)

      expect(Game.count).to eq(starting_count + 1)
    end

    it 'renders games#update' do
      new_name = 'different name'
      patch game_path(user_game, game: { name: new_name })

      expect(response).to redirect_to games_url
    end

    it 'renders games#destroy' do
      delete game_path(user_game)

      expect(response).to redirect_to(games_url)
      expect(response.body).to include(games_url)
    end
  end

  xdescribe "Authenticated access to another user's games" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user2_game) { create(:game, user: user2) }

    before :each do
      user2_game
      sign_in(user1)
    end

    it 'denies access to games#edit' do
      get edit_game_path(user2_game.id)

      expect(response).to_not be_successful
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_url)
    end

    it 'denies access to games#update' do
      new_name = 'completely different name'
      patch game_path(user2_game, game: { name: new_name })

      expect(response).to_not be_successful
      expect(response).to redirect_to root_url
    end

    it 'denies access to games#destroy' do
      delete game_path(user2_game)

      expect(response).to_not be_successful
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_url
    end
  end
end
