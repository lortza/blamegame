# frozen_string_literal: true

RSpec.describe User do
  let(:user) { build(:user) }

  context 'associations' do
    it { should have_many(:games) }
  end
end
