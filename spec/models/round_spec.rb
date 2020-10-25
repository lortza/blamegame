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
    let(:user) { create(:user) }
    let(:game) { create(:game, user: user) }
    let(:deck) { create(:deck, user: user) }
    let(:question) { create(:question, deck: deck) }
    let(:round) { create(:round, game: game, question: question) }
    let(:player1) { create(:player, game: game) }
    let(:player2) { create(:player, game: game) }

    before do
      round
      player1
      player2
    end

    it 'returns false if there are no submissions' do
      expect(round.complete?).to be(false)
    end

    it 'returns false when not all players have voted' do
      create(:submission, round: round, candidate_id: player2.id, voter_id: player1.id)
      expect(round.complete?).to be(false)
    end

    it 'returns true when all players have voted' do
      create(:submission, round: round, candidate_id: player2.id, voter_id: player1.id)
      create(:submission, round: round, candidate_id: player1.id, voter_id: player2.id)

      expect(round.complete?).to be(true)
    end
  end

  describe 'winner' do
    let(:user) { create(:user) }
    let(:game) { create(:game, user: user) }
    let(:deck) { create(:deck, user: user) }
    let(:question) { create(:question, deck: deck) }
    let(:round) { create(:round, game: game, question: question) }
    let(:player1) { create(:player, game: game) }
    let(:player2) { create(:player, game: game) }

    before do
      round
      player1
      player2
      allow(round).to receive(:all_votes_are_in?).and_return(true)
    end

    it 'returns the player with the most submissions in this round' do
      create(:submission, round: round, voter_id: player1.id, candidate_id: player1.id)
      create(:submission, round: round, voter_id: player2.id, candidate_id: player1.id)

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

  describe 'results_by_candidate' do
    let(:user) { create(:user) }
    let(:game) { create(:game, user: user) }
    let(:deck) { create(:deck, user: user) }
    let(:question) { create(:question, deck: deck) }
    let(:round) { create(:round, game: game, question: question) }
    let(:player1) { create(:player, game: game) }
    let(:player2) { create(:player, game: game) }

    before do
      round
      player1
      player2
    end

    it 'returns an array with voter name and list of voters' do
      create(:submission, round: round, voter_id: player1.id, candidate_id: player1.id)
      create(:submission, round: round, voter_id: player2.id, candidate_id: player1.id)

      expected_results = [[player1.name, [player1.name, player2.name]]]
      expect(round.results_by_candidate).to eq(expected_results)
    end

    it 'puts the player with most votes first' do
      player3 = create(:player, game: game)
      create(:submission, round: round, voter_id: player1.id, candidate_id: player2.id)
      create(:submission, round: round, voter_id: player2.id, candidate_id: player1.id)
      create(:submission, round: round, voter_id: player3.id, candidate_id: player2.id)

      expected_results = [[player2.name, [player1.name, player3.name]], [player1.name, [player2.name]]]
      expect(round.results_by_candidate).to eq(expected_results)
    end

    it 'orders by submission order in the case of a tie' do
      create(:submission, round: round, voter_id: player1.id, candidate_id: player2.id)
      create(:submission, round: round, voter_id: player2.id, candidate_id: player1.id)

      expected_results = [[player2.name, [player1.name]], [player1.name, [player2.name]]]
      expect(round.results_by_candidate).to eq(expected_results)
    end
  end

  describe 'last?' do
    let(:user) { create(:user) }
    let(:game) { create(:game, user: user) }
    let(:deck) { create(:deck, user: user) }
    let(:question1) { create(:question, deck: deck) }
    let(:question2) { create(:question, deck: deck) }
    let(:round1) { create(:round, game: game, question: question1, number: 1) }
    let(:round2) { create(:round, game: game, question: question2, number: 2) }

    before do
      round1
      round2
    end

    it 'returns true when it is the last round of the game' do
      expect(round1.last?).to be(false)
    end

    it 'returns false when it is not the last round of the game' do
      expect(round2.last?).to be(true)
    end
  end
end
