# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostTypesHelper, type: :helper do
  describe 'template?' do
    it 'displays ✓ if a description template is present' do
      post_type = build(:post_type)
      expect(helper.template?(post_type)).to eq('✓')
    end

    it 'returns nil if no template' do
      post_type = build(:post_type, description_template: nil)
      expect(helper.template?(post_type)).to eq(nil)
    end
  end
end
