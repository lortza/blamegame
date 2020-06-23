require 'rails_helper'

RSpec.describe Round, type: :model do
  context 'associations' do
    it { should belong_to(:game) }
    it { should belong_to(:question) }
    it { should have_many(:submissions) }
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

  describe 'results_by_nominee' do
    xit 'returns an array with player_id and vote count' do
    end

    xit 'it returns the highest votes first' do
    end

    xit 'returns nil when there is no winner? really?' do
    end
  end
end
