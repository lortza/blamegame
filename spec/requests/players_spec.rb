# frozen_string_literal: true

RSpec.describe 'Players' do
  describe 'Public access to players' do
    it 'renders players#new' do
      get new_player_path

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end

    it 'renders /play' do
      get join_game_path

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end

    it 'renders players#new_with_code' do
      user = create(:user)
      game = create(:game, user: user)
      path_with_code = "#{root_url}play/#{game.code}"

      get path_with_code

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end

    it 'permits access to players#create' do
      user = create(:user)
      game = create(:game, user: user)
      starting_count = Player.count
      player_attributes = build(:player, game_id: game.id).attributes

      post players_path(player: player_attributes)
      expect(Player.count).to eq(starting_count + 1)
    end
  end

  describe 'Cookie-restricted areas' do
    it 'denies access to players#index for players without cookies' do
      user = create(:user)
      game = create(:game, user: user)

      allow_any_instance_of(PlayersController).to receive(:valid_player_present?).with(game).and_return(false)
      get game_players_path(game)

      expect(response).to_not be_successful
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_url)
    end

    it 'renders players#index for players with cookies' do
      user = create(:user)
      game = create(:game, user: user)

      allow_any_instance_of(PlayersController).to receive(:valid_player_present?).with(game).and_return(true)
      get game_players_path(game)

      expect(response).to be_successful
      expect(response).to have_http_status(200)
    end
  end
end
