# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'associations' do
    it { should belong_to(:post_type) }
  end

  describe 'a valid post' do
    context 'when has valid params' do
      let(:post) { build(:post) }
      it 'is valid' do
        expect(post).to be_valid
      end

      it { should validate_presence_of(:date) }
      it { should validate_presence_of(:description) }
      it { should validate_presence_of(:post_type) }
    end
  end

  context 'delegations' do
    it { should delegate_method(:name).to(:post_type).with_prefix }
  end

  describe 'self.for_year' do
    it 'returns all records if no year is given' do
      post1 = create(:post, date: '2018-01-16')
      post2 = create(:post, date: '2019-01-16')
      given_year = ''

      expect(Post.for_year(given_year)).to include(post1, post2)
    end

    it 'returns only posts for a given year' do
      post1 = create(:post, date: '2018-01-16')
      post2 = create(:post, date: '2019-01-16')
      given_year = '2018'

      expect(Post.for_year(given_year)).to include(post1)
      expect(Post.for_year(given_year)).to_not include(post2)
    end
  end

  describe 'self.for_timeframe' do
    let!(:post_today) { create(:post, date: Time.zone.today) }
    let!(:post_past_week) { create(:post, date: (Time.zone.today - 3)) }
    let!(:post_past_month) { create(:post, date: (Time.zone.today - 15)) }
    let!(:post_past_quarter) { create(:post, date: (Time.zone.today - 80)) }

    it 'only returns posts for the given timeframe' do
      posts = Post.for_timeframe('Past Month')

      expect(posts).to include(post_today)
      expect(posts).to include(post_past_week)
      expect(posts).to include(post_past_month)
      expect(posts).to_not include(post_past_quarter)
    end

    it 'returns all posts when the given_year is "All Time"' do
      posts = Post.for_timeframe('All Time')
      expect(posts.count).to eq(4)
    end

    it 'returns all posts when the given_year is invalid' do
      posts = Post.for_timeframe('something invalid')
      expect(posts.count).to eq(4)
    end
  end

  describe 'self.search' do
    it 'returns all posts for current year if no terms are given' do
      last_year_post = create(:post, date: '2019-01-16')
      this_year_post = create(:post, date: '2020-01-16')

      allow(Report).to receive(:this_year).and_return('2020')
      results = Post.search

      expect(results).to_not include(last_year_post)
      expect(results).to include(this_year_post)
    end

    it 'if a year is given, it returns posts only from the given year' do
      last_year_post = create(:post, date: '2019-01-16')
      this_year_post = create(:post, date: '2020-01-16')
      given_year = '2019'

      results = Post.search(given_year: given_year)

      expect(results).to include(last_year_post)
      expect(results).to_not include(this_year_post)
    end

    it 'returns only post with both the given year and given term if present' do
      given_year = '2019'
      search_terms = 'kittens'

      right_year_right_term = create(:post, date: '2019-01-01', description: search_terms)
      right_year_wrong_term = create(:post, date: '2019-01-02', description: 'puppies')
      wrong_year_right_term = create(:post, date: '2020-01-16', description: search_terms)

      results = Post.search(given_year: given_year, search_terms: search_terms)

      expect(results).to include(right_year_right_term)
      expect(results).to_not include(right_year_wrong_term)
      expect(results).to_not include(wrong_year_right_term)
    end

    it 'returns all posts when given_year is "All Time"' do
      given_year = 'All Time'

      post1 = create(:post, date: '2018-01-01')
      post2 = create(:post, date: '2019-01-01')
      post3 = create(:post, date: '2020-01-01')

      results = Post.search(given_year: given_year)

      expect(results).to include(post1)
      expect(results).to include(post2)
      expect(results).to include(post3)
    end
  end

  describe 'self.for_words' do
    it 'returns all records if no search_term is given' do
      post1 = create(:post, description: 'flower')
      post2 = create(:post, description: 'moonwalk')
      search_term = ''

      expect(Post.for_words(search_term)).to include(post1, post2)
    end

    it 'returns only relevant records if a search term is present in the description' do
      post1 = create(:post, description: 'flower')
      post2 = create(:post, description: 'moonwalk')
      search_term = 'flower'

      expect(Post.for_words(search_term)).to include(post1)
      expect(Post.for_words(search_term)).to_not include(post2)
    end

    it 'returns only relevant records if a search term is present in the with_people field' do
      post1 = create(:post, with_people: 'Starsky')
      post2 = create(:post, with_people: 'Hutch')
      search_term = 'Starsky'

      expect(Post.for_words(search_term)).to include(post1)
      expect(Post.for_words(search_term)).to_not include(post2)
    end
  end

  describe 'word_cloud' do
    it 'returns a hash with words as keys' do
      post = build(:post, description: 'a a b b c')
      first_key = 'a'

      expect(post.word_cloud.keys.first).to eq(first_key)
    end

    it 'returns a hash with integers as values' do
      post = build(:post, description: 'a a b b c')
      first_value = 2

      expect(post.word_cloud.values.first).to eq(first_value)
    end

    it 'counts each unique word that appears in a descritption' do
      post = build(:post, description: 'a a b b c')
      expected_output = { 'a' => 2, 'b' => 2, 'c' => 1 }

      expect(post.word_cloud).to eq(expected_output)
    end

    it 'is case-insensitive' do
      post = build(:post, description: 'A a B b c')
      expected_output = { 'a' => 2, 'b' => 2, 'c' => 1 }

      expect(post.word_cloud).to eq(expected_output)
    end

    it 'removes unnecessary punctuation' do
      post = build(:post, description: 'a, a (b) b. c c, d')
      expected_output = { 'a' => 2, 'b' => 2, 'c' => 2, 'd' => 1 }

      expect(post.word_cloud).to eq(expected_output)
    end
  end
end
