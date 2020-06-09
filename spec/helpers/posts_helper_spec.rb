# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsHelper, type: :helper do
  describe 'timeframes_dropdown' do
    it 'lists all available years' do
      allow(Report).to receive(:available_years).and_return([2018, 2019])

      expect(helper.timeframes_dropdown).to include(2018)
      expect(helper.timeframes_dropdown).to include(2019)
    end

    it 'includes timeline options' do
      allow(Report).to receive(:available_years).and_return([2019])
      allow(Report).to receive(:timeframe_labels).and_return(['Past Week'])

      expect(helper.timeframes_dropdown).to include('Past Week')
    end

    it 'lists years before timeframe options' do
      allow(Report).to receive(:available_years).and_return([2019])
      allow(Report).to receive(:timeframe_labels).and_return(['Past Week'])

      expect(helper.timeframes_dropdown).to eq([2019, 'Past Week'])
    end
  end

  describe 'display_categories' do
    let!(:category1) { create(:category, name: 'lorem') }
    let!(:category2) { create(:category, name: 'ipsum') }
    let!(:post) { create(:post) }

    it 'displays a list of categories for the post' do
      post.categories << [category1, category2]
      expect(helper.display_categories(post)).to eq('lorem, ipsum')
    end

    it 'returns an empty string if no categories are available' do
      expect(helper.display_categories(post)).to eq('')
    end
  end
end
