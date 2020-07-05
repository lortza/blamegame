# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Players', type: :request do
  describe 'Public access to players' do

    it 'renders players#new' do
      get new_player_path

      expect(response).to be_successful
      expect(response).to render_template(:new)
    end

    xit 'renders players#create' do
      game = create(:game, :with_2_rounds)
      starting_count = Player.count
      player_attributes = build(:player, game_id: game.id).attributes

      post players_path(player: player_attributes)

      expect(response).to be_successful
      expect(Player.count).to eq(starting_count + 1)
    end

    it 'GET join_game_path' do
      get join_game_path
      expect(response).to be_successful
    end
  end
end
