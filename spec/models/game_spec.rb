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

  before :all do
    create_list(:question, 50)
  end

  before :each do
    game
    allow_any_instance_of(Game).to receive(:all_rounds_are_complete?).and_return(true)
    allow_any_instance_of(Game).to receive(:there_is_a_tie?).and_return(false)
  end

  describe 'self.current' do
    xit 'returns games that were created within the past hour' do
    end

    xit 'does not return games that are older than an hour' do
    end
  end

  describe 'self.past' do
    xit 'does not return games that were created within the past hour' do
    end

    xit 'returns games that are older than an hour' do
    end
  end

  describe 'activated?' do
    xit '' do

    end
  end

  describe 'generate_rounds' do
    it 'generates the max_rounds for a game' do
      expected_rounds = 3
      game = create(:game, max_rounds: expected_rounds)
      game.generate_rounds

      expect(game.rounds.size).to eq(expected_rounds)
    end
  end

  describe 'winner' do
    it 'returns nil if not all rounds are complete' do
      allow_any_instance_of(Game).to receive(:all_rounds_are_complete?).and_return(false)
      expect(game.winner).to eq(nil)
    end

    it 'returns nil if there is a tie between round winners' do
      allow_any_instance_of(Game).to receive(:there_is_a_tie?).and_return(true)
      expect(game.winner).to eq(nil)
    end

    it 'returns nil if there are no round winners' do
      allow_any_instance_of(Game).to receive(:no_rounds_have_a_winner?).and_return(true)
      expect(game.winner).to eq(nil)
    end

    it 'returns the winning player object' do
      game = create(:game)
      create(:round, game: game)
      player1 = create(:player, game: game)
      player2 = create(:player, game: game)
      player3 = create(:player, game: game)

      create(:submission,
        round: game.rounds.first,
        nominee_id: player1.id,
        nominator_id: player2.id)
      create(:submission,
        round: game.rounds.first,
        nominee_id: player2.id,
        nominator_id: player1.id)
      create(:submission,
        round: game.rounds.first,
        nominee_id: player1.id,
        nominator_id: player3.id)

      expect(game.winner).to eq(player1)
    end
  end
end
