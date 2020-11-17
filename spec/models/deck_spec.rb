# frozen_string_literal: true

RSpec.describe Deck do
  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:questions) }
    it { should have_many(:game_decks) }
    it { should have_many(:games).through(:game_decks) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'self.default_decks' do
    let(:user) { create(:user) }
    let(:default_deck) { create(:deck, user: user, name: Deck::DEFAULT_DECK_NAMES.first) }
    let(:regular_deck) { create(:deck, user: user) }

    before do
      default_deck
      regular_deck
    end

    it 'includes only the default decks' do
      results = described_class.default_decks
      expect(results).to include(default_deck)
    end

    it 'excludes decks that are not default' do
      results = described_class.default_decks
      expect(results).to_not include(regular_deck)
    end
  end

  describe 'default?' do
    let(:user) { create(:user) }
    let(:default_deck) { create(:deck, user: user, name: Deck::DEFAULT_DECK_NAMES.first) }
    let(:regular_deck) { create(:deck, user: user) }

    it 'returns true for a default decks' do
      expect(default_deck.default?).to eq(true)
    end

    it 'returns false for a deck that is not default' do
      expect(regular_deck.default?).to eq(false)
    end
  end
end
