# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:post_categories) }
    it { should have_many(:posts).through(:post_categories) }
  end
end
