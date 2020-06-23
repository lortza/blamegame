# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubmissionsHelper, type: :helper do
  describe 'players_minus_nominator' do
    let!(:game) { create(:game) }
    let!(:player1) { create(:player, game: game) }

    it 'returns a list of players' do
      player2 = create(:player, game: game)
      expected_players = helper.players_minus_nominator(game, player1)

      expect(expected_players).to_not include(player1)
      expect(expected_players).to include(player2)
    end

    it 'returns all players when nominee is nil' do
      player2 = create(:player, game: game)
      expected_players = helper.players_minus_nominator(game, nil)

      expect(expected_players).to include(player1)
      expect(expected_players).to include(player2)
    end

    it 'returns [] when there is only 1 player' do
      expected_players = helper.players_minus_nominator(game, player1)

      expect(expected_players).to eq([])
    end
  end
end
