require 'rails_helper'

RSpec.describe Player, type: :model do
  context 'associations' do
    it { should belong_to(:game) }
  end
end
