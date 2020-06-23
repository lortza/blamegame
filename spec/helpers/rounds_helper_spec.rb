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
    let!(:game) { create(:game) }

  end
end
