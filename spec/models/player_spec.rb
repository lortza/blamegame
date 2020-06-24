# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  context 'associations' do
    it { should belong_to(:game) }
    it { should have_many(:submissions) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    # it { should validate_uniqueness_of(:name).scoped_to(:game_id) }
  end
end
