# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :game
  belongs_to :question
  has_many :submissions, dependent: :destroy

  validates :number, presence: true

  def winner
    return nil unless all_votes_are_in?

    vote_results = votes_by_nominee
    return nil if there_is_a_tie?(vote_results)

    winning_player_id = vote_results.first[0]
    @winner ||= game.players.find(winning_player_id)
  end

  def complete?
    submissions.present? && (submissions.size == game.players.size)
  end

  def results_by_nominee
    nominee_ids = submissions.pluck(:nominee_id).uniq
    names_dictionary = nominee_names(nominee_ids)
    results = count_submissions_for_each_nominee(names_dictionary)
    results.sort_by { |_nominee, nominators| -nominators.count }
  end

  private

  def nominee_names(nominee_ids)
    names_dictionary = {}
    nominee_ids.each do |nominee_id|
      nominee_name = Player.find(nominee_id).name
      names_dictionary[nominee_name] = []
    end
    names_dictionary
  end

  def count_submissions_for_each_nominee(names_dictionary)
    submissions.each do |submission|
      nominator_name = Player.find(submission.nominator_id).name
      names_dictionary[submission.nominee.name] << nominator_name
    end
    names_dictionary
  end

  def votes_by_nominee
    results = submissions.group(:nominee_id).count
    results.sort_by { |_nominee, votes| -votes }
  end

  def there_is_a_tie?(vote_results)
    return false if vote_results.size == 1

    vote_results.first[1] == vote_results.second[1]
  end

  def all_votes_are_in?
    complete?
  end
end
