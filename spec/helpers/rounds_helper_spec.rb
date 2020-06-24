# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoundsHelper, type: :helper do
  let(:game) { create(:game) }
  let(:round1) { create(:round, game: game) }
  let(:round2) { create(:round, game: game) }

  before do
    game
    round1
    round2
  end

  describe 'next_round_submission' do
    it 'returns a new submission link' do
      output = helper.next_round_submission(round1)
      expect(output).to include('/submissions/new')
    end

    it 'defines next round as the one after the current one' do
      output = helper.next_round_submission(round1)
      expect(output).to include(round2.id.to_s)
    end
  end

  describe 'display_winner' do
    let(:player) { create(:player, game: game, name: 'lorem') }

    it 'displays the round winner name' do
      allow_any_instance_of(Round).to receive(:winner).and_return(player)
      expect(display_winner(round1)).to eq(player.name)
    end

    it 'displays the game winner name' do
      allow_any_instance_of(Game).to receive(:winner).and_return(player)
      expect(display_winner(game)).to eq(player.name)
    end

    it 'displays a tie message if there is no winner' do
      allow_any_instance_of(Game).to receive(:winner).and_return([])
      expect(display_winner(game).downcase).to include('tie')
    end
  end
end
