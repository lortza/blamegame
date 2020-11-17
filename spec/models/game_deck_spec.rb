# frozen_string_literal: true

RSpec.describe GameDeck do
  context 'associations' do
    it { should belong_to(:deck) }
    it { should belong_to(:game) }
  end
end
