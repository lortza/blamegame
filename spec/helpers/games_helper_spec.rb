# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GamesHelper, type: :helper do
  describe 'display_players' do
    let!(:game) { create(:game) }

    it 'returns a link to add players if there are no players' do
      output = helper.display_players(game)
      expect(output).to include('Add Players')
    end

    it 'returns a list of players if there are players' do
      player1 = create(:player, game: game)
      player2 = create(:player, game: game)
      expected_output = "#{player1.name}, #{player2.name}"
      actual_output = helper.display_players(game)

      expect(actual_output).to eq(expected_output)
    end
  end
end
