# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportsHelper, type: :helper do
  describe 'sizer' do
    it 'allows a max size of 250' do
      expect(helper.sizer(300)).to eq(250)
    end

    it 'allows a min size of 5' do
      expect(helper.sizer(3)).to eq(5)
    end

    it 'returns the input + 2 for all other cases' do
      expect(helper.sizer(45)).to eq(47)
    end
  end
end
