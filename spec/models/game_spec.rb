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
    # allow_any_instance_of(Game).to receive(:complete?).and_return(true)
    allow_any_instance_of(Game).to receive(:there_is_a_tie?).and_return(false)
  end

  describe 'self.current' do
    it 'returns games that were created within the past hour' do
      game = create(:game, created_at: 30.minutes.ago)
      expect(Game.current).to include(game)
    end

    it 'does not return games that are older than an hour' do
      game = create(:game, created_at: 1.5.hours.ago)
      expect(Game.current).to_not include(game)
    end
  end

  describe 'self.past' do
    it 'does not return games that were created within the past hour' do
      game = create(:game, created_at: 30.minutes.ago)
      expect(Game.past).to_not include(game)
    end

    it 'returns games that are older than an hour' do
      game = create(:game, created_at: 1.5.hours.ago)
      expect(Game.past).to include(game)
    end
  end

  describe 'expired?' do
    it 'returns true if the game is older than 1 hour' do
      game = create(:game, created_at: 2.hours.ago)
      expect(game.expired?).to be(true)
    end

    it 'returns false if the game is less than an hour old' do
      game = create(:game, created_at: 30.minutes.ago)
      expect(game.expired?).to be(false)
    end
  end

  describe 'activated?' do
    xit '' do

    end
  end

  describe 'complete?' do
    it 'returns true if all rounds are complete' do
      game
      allow_any_instance_of(Round).to receive(:complete?).and_return(true)

      expect(game.complete?).to be(true)
    end

    it 'returns false if all rounds are NOT complete' do
      game
      round1 = game.rounds.first
      round2 = game.rounds.last
      allow(round1).to receive(:complete?).and_return(true)
      allow(round2).to receive(:complete?).and_return(false)

      expect(game.complete?).to be(false)
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
      allow_any_instance_of(Game).to receive(:complete?).and_return(false)
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
