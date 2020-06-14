require 'rails_helper'

RSpec.describe Submission, type: :model do
  context 'associations' do
    it { should belong_to(:round) }
    it { should belong_to(:nominee).class_name('Player') }
    it { should belong_to(:nominator).class_name('Player') }
  end

  context 'validations' do
    # wip
    # validates :nominator, uniqueness: { scope: :round_id,
  end
end
