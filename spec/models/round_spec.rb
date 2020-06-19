require 'rails_helper'

RSpec.describe Round, type: :model do
  context 'associations' do
    it { should belong_to(:game) }
    it { should belong_to(:question) }
    it { should have_many(:submissions) }
  end

  context 'validations' do

  end

  describe 'complete?' do
    it 'returns true when all players have voted' do

    end

    it 'returns false when not all players have voted' do

    end
  end

  # it 'returns nil when no rounds have winners' do
  #   game = create(:game)
  #   create(:round, game: game)
  #   player1 = create(:player, game: game)
  #   player2 = create(:player, game: game)
  #
  #   create(:submission,
  #     round: game.rounds.first,
  #     nominee_id: player1.id,
  #     nominator_id: player2.id)
  #   create(:submission,
  #     round: game.rounds.first,
  #     nominee_id: player2.id,
  #     nominator_id: player1.id)
  #
  #   expect(game.winner).to eq(nil)
  # end
end
