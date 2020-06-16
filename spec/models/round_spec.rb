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
end
