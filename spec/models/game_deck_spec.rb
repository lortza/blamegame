# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameDeck, type: :model do
  context 'associations' do
    it { should belong_to(:deck) }
    it { should belong_to(:game) }
  end
end
