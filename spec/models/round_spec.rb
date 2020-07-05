# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Round, type: :model do
  context 'associations' do
    it { should belong_to(:game) }
    it { should belong_to(:question) }
    it { should have_many(:submissions) }
  end

  context 'validations' do
    it { should validate_presence_of(:number) }
  end

  describe 'complete?' do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game) }
    let(:player1) { create(:player, game: game) }
    let(:player2) { create(:player, game: game) }

    it 'returns false if there are no submissions' do
      expect(round.complete?).to be(false)
    end

    it 'returns false when not all players have voted' do
      create(:submission, round: round, nominee_id: player2.id, nominator_id: player1.id)
      expect(round.complete?).to be(false)
    end

    it 'returns true when all players have voted' do
      create(:submission, round: round, nominee_id: player2.id, nominator_id: player1.id)
      create(:submission, round: round, nominee_id: player1.id, nominator_id: player2.id)

      expect(round.complete?).to be(true)
    end
  end

  describe 'winner' do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game) }
    let(:player1) { create(:player, game: game) }
    let(:player2) { create(:player, game: game) }

    before do
      round
      player1
      player2
      allow(round).to receive(:all_votes_are_in?).and_return(true)
    end

    it 'returns the player with the most submissions in this round' do
      create(:submission, round: round, nominator_id: player1.id, nominee_id: player1.id)
      create(:submission, round: round, nominator_id: player2.id, nominee_id: player1.id)

      expect(round.winner).to eq(player1)
    end

    it 'returns nil if all submissions not all submissions are in' do
      allow(round).to receive(:all_votes_are_in?).and_return(false)
      expect(round.winner).to eq(nil)
    end

    it 'returns nil in the case of a tie' do
      allow(round).to receive(:there_is_a_tie?).and_return(true)
      expect(round.winner).to eq(nil)
    end
  end

  describe 'results_by_nominee' do
    let(:game) { create(:game) }
    let(:round) { create(:round, game: game) }
    let(:player1) { create(:player, game: game) }
    let(:player2) { create(:player, game: game) }

    before do
      round
      player1
      player2
    end

    it 'returns an array with nominator name and list of nominators' do
      create(:submission, round: round, nominator_id: player1.id, nominee_id: player1.id)
      create(:submission, round: round, nominator_id: player2.id, nominee_id: player1.id)

      expected_results = [[player1.name, [player1.name, player2.name]]]
      expect(round.results_by_nominee).to eq(expected_results)
    end

    it 'puts the player with most votes first' do
      player3 = create(:player, game: game)
      create(:submission, round: round, nominator_id: player1.id, nominee_id: player2.id)
      create(:submission, round: round, nominator_id: player2.id, nominee_id: player1.id)
      create(:submission, round: round, nominator_id: player3.id, nominee_id: player2.id)

      expected_results = [[player2.name, [player1.name, player3.name]], [player1.name, [player2.name]]]
      expect(round.results_by_nominee).to eq(expected_results)
    end

    it 'orders by submission order in the case of a tie' do
      create(:submission, round: round, nominator_id: player1.id, nominee_id: player2.id)
      create(:submission, round: round, nominator_id: player2.id, nominee_id: player1.id)

      expected_results = [[player2.name, [player1.name]], [player1.name, [player2.name]]]
      expect(round.results_by_nominee).to eq(expected_results)
    end
  end
end
