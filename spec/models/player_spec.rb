# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  context 'associations' do
    it { should belong_to(:game) }
    it { should have_many(:submissions) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:game_id) }
    # it { should validate_uniqueness_of(:name).scoped_to(:game_id) }
  end

  # Setup needed for all specs
  let(:user) { create(:user) }
  let(:game) { create(:game, user: user) }
  let(:deck) { create(:deck, user: user) }
  let(:question1) { create(:question, deck: deck) }
  let(:question2) { create(:question, deck: deck) }
  let(:round1) { create(:round, game: game, question: question1, number: 1) }
  let(:round2) { create(:round, game: game, question: question2, number: 2) }
  let(:player1) { create(:player, game: game) }
  let(:player2) { create(:player, game: game) }
  let(:player3) { create(:player, game: game) }

  describe 'rounds_won' do
    it 'returns a count of rounds won in that game' do
      create(:submission, round: round1, candidate_id: player1.id, voter_id: player2.id)
      create(:submission, round: round1, candidate_id: player1.id, voter_id: player1.id)

      expect(player1.rounds_won).to eq(1)
      expect(player2.rounds_won).to eq(0)
    end

    it 'handles multiple rounds' do
      create(:submission, round: round1, candidate_id: player1.id, voter_id: player2.id)
      create(:submission, round: round1, candidate_id: player1.id, voter_id: player1.id)
      create(:submission, round: round2, candidate_id: player1.id, voter_id: player2.id)
      create(:submission, round: round2, candidate_id: player1.id, voter_id: player1.id)

      expect(player1.rounds_won).to eq(2)
      expect(player2.rounds_won).to eq(0)
    end
  end

  describe 'votes' do
    it 'returns the number of votes a player had in the whole game' do
      create(:submission, round: round1, candidate_id: player1.id, voter_id: player2.id)
      create(:submission, round: round1, candidate_id: player1.id, voter_id: player1.id)
      create(:submission, round: round1, candidate_id: player2.id, voter_id: player3.id)

      create(:submission, round: round2, candidate_id: player1.id, voter_id: player2.id)
      create(:submission, round: round2, candidate_id: player3.id, voter_id: player1.id)
      create(:submission, round: round2, candidate_id: player2.id, voter_id: player3.id)

      expect(player1.votes).to eq(3)
      expect(player2.votes).to eq(2)
      expect(player3.votes).to eq(1)
    end
  end
end
