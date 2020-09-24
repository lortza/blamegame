# frozen_string_literal: true

# == Schema Information
#
# Table name: rounds
#
#  id          :bigint           not null, primary key
#  number      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  game_id     :bigint           not null
#  question_id :bigint           not null
#
# Indexes
#
#  index_rounds_on_game_id      (game_id)
#  index_rounds_on_question_id  (question_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (question_id => questions.id)
#
class Round < ApplicationRecord
  belongs_to :game
  belongs_to :question
  has_many :submissions, dependent: :destroy

  validates :number, presence: true

  def winner
    return nil unless all_votes_are_in?

    vote_results = votes_by_candidate
    return nil if there_is_a_tie?(vote_results)

    winning_player_id = vote_results.first[0]
    @winner ||= game.players.find(winning_player_id)
  end

  def complete?
    submissions.present? && (submissions.size == game.players.size)
  end

  def results_by_candidate
    candidate_ids = submissions.pluck(:candidate_id).uniq
    names_dictionary = candidate_names(candidate_ids)
    results = count_submissions_for_each_candidate(names_dictionary)
    results.sort_by { |_candidate, voters| -voters.count }
  end

  private

  def candidate_names(candidate_ids)
    names_dictionary = {}
    candidate_ids.each do |candidate_id|
      candidate_name = Player.find(candidate_id).name
      names_dictionary[candidate_name] = []
    end
    names_dictionary
  end

  def count_submissions_for_each_candidate(names_dictionary)
    submissions.each do |submission|
      voter_name = Player.find(submission.voter_id).name
      names_dictionary[submission.candidate.name] << voter_name
    end
    names_dictionary
  end

  def votes_by_candidate
    results = submissions.group(:candidate_id).count
    results.sort_by { |_candidate, votes| -votes }
  end

  def there_is_a_tie?(vote_results)
    return false if vote_results.size == 1

    vote_results.first[1] == vote_results.second[1]
  end

  def all_votes_are_in?
    complete?
  end
end
