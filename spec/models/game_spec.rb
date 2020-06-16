require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:players) }
    it { should have_many(:rounds) }
  end

  let(:game) { create(:game, :with_3_players, :with_2_rounds) }
  let(:player1) { game.player.first }
  let(:player2) { game.player.second }
  let(:player3) { game.player.third }

  before do
    game
    allow_any_instance_of(Game).to receive(:all_rounds_are_complete?).and_return(true)
    allow_any_instance_of(Game).to receive(:there_is_a_tie?).and_return(false)
  end

  xdescribe 'winner' do

    it 'returns nil if not all rounds are complete' do
      allow_any_instance_of(Game).to receive(:all_rounds_are_complete?).and_return(false)
      expect(game.winner).to eq(nil)
    end

    it 'returns nil if there is a tie' do
      allow_any_instance_of(Game).to receive(:there_is_a_tie?).and_return(true)
      allow_any_instance_of(Game).to receive(:tally_rounds).and_return([])

      expect(game.winner).to eq(nil)
    end

    it 'returns the winning player object' do
      game = create(:game, :with_2_rounds)
      player1 = create(:player, game: game)
      player2 = create(:player, game: game)
      create(:submission,
        round: game.rounds.first,
        nominee_id: player1.id,
        nominator_id: player2.id)
      create(:submission,
        round: game.rounds.first,
        nominee_id: player2.id,
        nominator_id: player1.id)
      create(:submission,
        round: game.rounds.second,
        nominee_id: player1.id,
        nominator_id: player2.id)
      create(:submission,
        round: game.rounds.second,
        nominee_id: player2.id,
        nominator_id: player1.id)

      expect(game.winner).to eq(nil)

    end
  end

  xdescribe '#tally_rounds' do
    it 'returns an array of player ids and counts' do

    end
  end
end
