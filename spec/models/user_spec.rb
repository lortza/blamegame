# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  context 'associations' do
    # it { should have_many(:posts).through(:post_types) }
  end
end
