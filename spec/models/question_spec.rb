# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'associations' do
    it { should have_many(:rounds) }
  end

  context 'validations' do
    it { should validate_presence_of(:text) }
  end

  describe 'self.search' do
    let(:user) { create(:user) }
    let(:deck) { create(:deck, user: user) }
    let!(:question1) do
      create(:question,
             deck: deck,
             text: 'holy moly batman?')
    end

    let!(:question2) do
      create(:question,
             deck: deck,
             text: 'do you like bat kitties?')
    end

    it 'returns all questions if no search terms are given' do
      results = Question.search(field: :text, terms: '')

      expect(results).to include(question1)
      expect(results).to include(question1)
      expect(results).to include(question2)
    end

    it 'returns only matches' do
      results = Question.search(field: :text, terms: 'batman')

      expect(results).to include(question1)
      expect(results).to_not include(question2)
    end

    it 'returns fuzzy matches' do
      results = Question.search(field: :text, terms: 'bat')

      expect(results).to include(question1)
      expect(results).to include(question2)
    end
  end

  describe 'self.without_adult_content' do
    let(:user) { create(:user) }
    let(:deck) { create(:deck, user: user) }
    let!(:question1) do
      create(:question, deck: deck, adult_rating: true)
    end

    let!(:question2) do
      create(:question, deck: deck, adult_rating: false)
    end

    it 'excludes any questions with adult content' do
      results = Question.without_adult_content

      expect(results).to_not include(question1)
      expect(results).to include(question2)
    end
  end
end
