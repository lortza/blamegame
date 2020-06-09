# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostCategory, type: :model do
  context 'associations' do
    it { should belong_to(:post) }
    it { should belong_to(:category) }
  end
end
