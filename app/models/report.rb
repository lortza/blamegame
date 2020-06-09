# frozen_string_literal: true

class Report < ApplicationRecord
  TIMEFRAMES = {
    'Past Week' => 7,
    'Past Month' => 30,
    'Past Quarter' => 90,
    'Past Half Year' => 182,
    'Past Year' => 365,
    'All Time' => nil
  }.freeze

  class << self
    def timeframe_labels
      TIMEFRAMES.keys
    end

    def this_year
      Time.zone.today.year
    end

    def available_years(model = Post, date_field = :date)
      model.all.pluck(date_field).map(&:year).uniq.sort.reverse
    end

    def generate_word_cloud(posts:, minimum_count:)
      words = posts.each_with_object({}) do |post, words_hash|
        words_hash.merge!(post.word_cloud) do |_k, hash_value, incoming_value|
          hash_value + incoming_value
        end
      end
      filtered_words = filter_minimum_count(words, minimum_count)
      filter_out_common(filtered_words)
    end

    private

    def filter_minimum_count(words_hash, minimum)
      words_hash.select { |_word, count| count >= minimum }
    end

    def sort_descending_count(words_hash)
      words_hash.sort_by { |_word, count| -count }
    end

    def filter_out_common(words_hash)
      common_words = %w[a am an at as and be been for from had have i in is it of on that the this to was]
      words_hash.select { |word, _count| common_words.exclude?(word) }
    end
  end
end
