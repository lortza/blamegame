# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:players) }
    it { should have_many(:rounds) }
    it { should have_many(:game_decks) }
    it { should have_many(:decks).through(:game_decks) }
  end

  context 'validations' do
    it { should validate_presence_of(:max_rounds) }
    it { should validate_numericality_of(:max_rounds) }
  end

  let(:user) { create(:user) }
  let(:game) { create(:game, :with_3_players, user: user) }
  let(:deck) { create(:deck, user: user) }
  let(:question) { create(:question, deck: deck) }
  let(:round) { create(:round, game: game, question: question) }
  let(:player1) { game.players.first }
  let(:player2) { game.players.second }
  let(:player3) { game.players.third }

  before :each do
    game
  end

  describe 'self.current' do
    it 'returns games that were created within the past hour' do
      game = create(:game, user: user, created_at: 30.minutes.ago)
      expect(Game.current).to include(game)
    end

    it 'does not return games that are older than an hour' do
      game = create(:game, user: user, created_at: 1.5.hours.ago)
      expect(Game.current).to_not include(game)
    end
  end

  describe 'self.past' do
    it 'does not return games that were created within the past hour' do
      game = create(:game, user: user, created_at: 30.minutes.ago)
      expect(Game.past).to_not include(game)
    end

    it 'returns games that are older than an hour' do
      game = create(:game, user: user, created_at: 1.5.hours.ago)
      expect(Game.past).to include(game)
    end
  end

  describe 'expired?' do
    let(:user) { create(:user) }
    let(:deck) { create(:deck, user: user) }
    let(:question) { create(:question, deck: deck) }
    let(:round) { create(:round, game: game, question: question) }
    let(:game) { create(:game) }
    let(:player1) { create(:player, game: game) }
    let(:player2) { create(:player, game: game) }
    let(:submission1) { create(:submission, round: round, candidate_id: player1.id, voter_id: player2.id) }
    let(:submission2) { create(:submission, round: round, candidate_id: player2.id, voter_id: player1.id) }

    before do
      submission1
      submission2
    end

    it 'returns true if the game is older than 2 hours regardless of completion' do
      allow_any_instance_of(Game).to receive(:created_at).and_return(2.5.hours.ago)
      allow_any_instance_of(Submission).to receive(:created_at).and_return(2.5.hours.ago)

      expect(game.expired?).to be(true)
    end

    it 'returns false if the game is less than 2 hours old' do
      allow_any_instance_of(Game).to receive(:created_at).and_return(1.hour.ago)
      allow_any_instance_of(Submission).to receive(:created_at).and_return(5.minutes.ago)

      expect(game.expired?).to be(false)
    end

    it 'returns true if the last submission was more than 30 minutes ago' do
      submission2.update(created_at: 35.minutes.ago)

      expect(game.expired?).to be(true)
    end
  end

  describe 'active?' do
    it 'returns true if players are ready and the game is not expired' do
      game = create(:game, players_ready: true)
      allow(game).to receive(:expired?).and_return(false)

      expect(game.active?).to be(true)
    end

    it 'returns false if players are ready and the game is expired' do
      game = create(:game, players_ready: true)
      allow(game).to receive(:expired?).and_return(true)

      expect(game.active?).to be(false)
    end

    it 'returns false if players are not ready and the game is not expired' do
      game = create(:game, players_ready: false)
      allow(game).to receive(:expired?).and_return(false)

      expect(game.active?).to be(false)
    end

    it 'returns false if players are not ready and the game is expired' do
      game = create(:game, players_ready: false)
      allow(game).to receive(:expired?).and_return(true)

      expect(game.active?).to be(false)
    end
  end

  describe 'complete?' do
    let(:user) { create(:user) }
    let(:deck) { create(:deck, user: user) }
    let(:question1) { create(:question, deck: deck) }
    let(:question2) { create(:question, deck: deck) }
    let(:game) { create(:game, user: user) }
    let(:round1) { create(:round, game: game, question: question1) }
    let(:round2) { create(:round, game: game, question: question1) }
    let(:player1) { create(:player, game: game) }
    let(:player2) { create(:player, game: game) }
    let(:submission1) { create(:submission, round: round, candidate_id: player1.id, voter_id: player2.id) }
    let(:submission2) { create(:submission, round: round, candidate_id: player2.id, voter_id: player1.id) }

    before do
      round1
      round2
    end

    it 'returns true if all rounds are complete' do
      allow_any_instance_of(Round).to receive(:complete?).and_return(true)
      expect(game.complete?).to be(true)
    end

    it 'returns false if all rounds are NOT complete' do
      allow(round1).to receive(:complete?).and_return(true)
      allow(round2).to receive(:complete?).and_return(false)

      expect(game.complete?).to be(false)
    end
  end

  describe 'generate_rounds' do
    let(:deck1) { create(:deck, user: user) }
    let(:deck2) { create(:deck, user: user) }
    let(:question1) { create(:question, deck: deck1, adult_rating: true) }
    let(:question2) { create(:question, deck: deck2) }
    let(:question3) { create(:question, deck: deck2) }

    it 'does not create more rounds than there are available questions' do
      question1
      question2
      question_count = 2
      game_max_rounds = 3
      game = create(:game,
                    user: user,
                    deck_ids: [deck1.id, deck2.id],
                    max_rounds: game_max_rounds)
      game.generate_rounds

      expect(game.rounds.size).to eq(question_count)
    end

    it "does not create more rounds than the game's max_rounds" do
      question1
      question2
      question3
      question_count = 3
      game_max_rounds = 2
      game = create(:game,
                    user: user,
                    deck_ids: [deck1.id, deck2.id],
                    max_rounds: game_max_rounds)
      game.generate_rounds

      expect(game.rounds.size).to eq(game_max_rounds)
    end

    it 'excludes adult questions when requested' do
      question1
      game = create(:game, user: user,
                           adult_content_permitted: false,
                           max_rounds: 1,
                           deck_ids: [deck1.id])
      game.generate_rounds

      expect(game.rounds).to eq([])
    end

    it 'includes adult questions when requested' do
      question1
      game = create(:game, user: user,
                           adult_content_permitted: true,
                           max_rounds: 1,
                           deck_ids: [deck1.id])
      game.generate_rounds

      expect(game.rounds.first.question).to eq(question1)
    end

    it 'includes questions from the specified decks' do
      question1
      question2
      game = create(:game, user: user,
                           adult_content_permitted: true,
                           max_rounds: 2,
                           deck_ids: [deck1.id, deck2.id])
      game.generate_rounds
      questions = game.rounds.map(&:question)

      expect(questions).to include(question1)
      expect(questions).to include(question2)
    end

    it 'excludes questions from all other decks' do
      question1
      question2
      game = create(:game, user: user,
                           adult_content_permitted: true,
                           max_rounds: 2,
                           deck_ids: [deck1.id])
      game.generate_rounds
      questions = game.rounds.map(&:question)

      expect(questions).to include(question1)
      expect(questions).to_not include(question2)
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
      user = create(:user)
      game = create(:game, user: user)
      deck = create(:deck, user: user)
      question = create(:question, deck: deck)
      create(:round, question: question, game: game)
      player1 = create(:player, game: game)
      player2 = create(:player, game: game)
      player3 = create(:player, game: game)

      create(:submission,
             round: game.rounds.first,
             candidate_id: player1.id,
             voter_id: player2.id)
      create(:submission,
             round: game.rounds.first,
             candidate_id: player2.id,
             voter_id: player1.id)
      create(:submission,
             round: game.rounds.first,
             candidate_id: player1.id,
             voter_id: player3.id)

      expect(game.winner).to eq(player1)
    end
  end

  describe 'submissions' do
    it 'returns all submissions for a game' do
      submission1 = create(:submission, round: round, candidate_id: player1.id, voter_id: player2.id)
      submission2 = create(:submission, round: round, candidate_id: player2.id, voter_id: player1.id)

      expect(game.submissions).to include(submission1)
      expect(game.submissions).to include(submission2)
    end

    it 'excludes submissions that are not for this game' do
      game2 = create(:game, user: user)
      question2 = create(:question, deck: deck)
      round_g2 = create(:round, game: game2, question: question2)
      player1 = create(:player, game: game2)
      player2 = create(:player, game: game2)

      submission1 = create(:submission, round: round, candidate_id: player1.id, voter_id: player2.id)
      submission2 = create(:submission, round: round, candidate_id: player2.id, voter_id: player1.id)
      submission3 = create(:submission, round: round_g2, candidate_id: player1.id, voter_id: player2.id)
      submission4 = create(:submission, round: round_g2, candidate_id: player2.id, voter_id: player1.id)

      expect(game2.submissions).to_not include(submission1)
      expect(game2.submissions).to_not include(submission2)
      expect(game2.submissions).to include(submission3)
      expect(game2.submissions).to include(submission4)
    end
  end

  describe 'total_rounds' do
    xit 'returns a count of rounds that are in-play for a game' do
    end
  end
end
