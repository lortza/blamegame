# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserDataSetupService, type: :service do
  let(:user) { create(:user) }

  describe 'self.setup' do
    context 'post types' do
      it 'creates new records' do
        post_type_count_before = user.post_types.count
        expect(post_type_count_before).to eq(0)

        UserDataSetupService.setup(user)
        user.reload
        post_type_count_after = user.post_types.count

        expect(post_type_count_after).to eq(4)
      end

      it 'includes name and template' do
        UserDataSetupService.setup(user)
        user.reload
        merit = PostType.find_by(name: 'Merit')

        expect(merit.description_template).to include('Problem')
      end
    end

    context 'categories' do
      it 'creates new records' do
        category_count_before = user.categories.count
        expect(category_count_before).to eq(0)

        UserDataSetupService.setup(user)
        user.reload
        category_count_after = user.categories.count

        expect(category_count_after).to eq(5)
      end
    end
  end
end
