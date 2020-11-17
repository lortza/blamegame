# frozen_string_literal: true

RSpec.describe Submission do
  context 'associations' do
    it { should belong_to(:round) }
    it { should belong_to(:candidate).class_name('Player') }
    it { should belong_to(:voter).class_name('Player') }
  end

  context 'validations' do
    # wip
    # validates :voter, uniqueness: { scope: :round_id, message: "you only get to vote once per round" }
  end

  describe 'self.for_player' do
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

    it 'includes submissions for a specific candidate' do
      create(:submission, round: round1, candidate_id: player1.id, voter_id: player2.id)
      candidate_submissions = described_class.for_player(player1)

      expect(candidate_submissions).to eq(1)
    end

    it 'excludes submissions not for that candidate' do
      create(:submission, round: round1, candidate_id: player2.id, voter_id: player3.id)
      candidate_submissions = described_class.for_player(player1)

      expect(candidate_submissions).to eq(0)
    end

    it "doesn't care about who voted for that candidate" do
      create(:submission, round: round1, candidate_id: player2.id, voter_id: player1.id)
      candidate_submissions = described_class.for_player(player1)

      expect(candidate_submissions).to eq(0)
    end

    it 'includes votes across all rounds' do
      create(:submission, round: round1, candidate_id: player1.id, voter_id: player1.id)
      create(:submission, round: round2, candidate_id: player1.id, voter_id: player2.id)
      create(:submission, round: round2, candidate_id: player2.id, voter_id: player3.id)
      candidate_submissions = described_class.for_player(player1)

      expect(candidate_submissions).to eq(2)
    end
  end
end
