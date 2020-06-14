require 'rails_helper'

RSpec.describe Round, type: :model do
  context 'associations' do
    it { should belong_to(:game) }
    it { should belong_to(:question) }
    it { should belong_to(:winner).class_name('Player') }
    it { should have_many(:submissions) }
  end
end
