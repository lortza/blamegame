# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoundsHelper, type: :helper do
  let(:game) { create(:game) }

  before do
    game.generate_rounds
  end

  describe 'next_round_submission' do
    it 'returns a new submission link' do
      round = game.rounds.first
      output = helper.next_round_submission(round)
      expect(output).to include('/submissions/new')
    end

    it 'defines next round as the one after the current one' do
      round = game.rounds.first
      output = helper.next_round_submission(round)
      expect(output).to include('/submissions/new')
    end
  end

  describe 'display_winner' do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game) }
    let(:player) { create(:player, game: game, name: 'lorem') }

    it 'displays the round winner name' do
      round
      allow_any_instance_of(Round).to receive(:winner).and_return(player)
      expect(display_winner(round)).to eq(player.name)
    end

    it 'displays the game winner name' do
      game
      allow_any_instance_of(Game).to receive(:winner).and_return(player)
      expect(display_winner(game)).to eq(player.name)
    end

    it 'displays a tie message if there is no winner' do
      allow_any_instance_of(Game).to receive(:winner).and_return([])
      expect(display_winner(game).downcase).to include('tie')
    end
  end
end
