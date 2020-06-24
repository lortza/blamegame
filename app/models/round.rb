# frozen_string_literal: true

class Round < ApplicationRecord
  belongs_to :game
  belongs_to :question
  has_many :submissions, dependent: :destroy

  def winner
    return unless all_votes_are_in?

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
    results = {}

    nominee_ids.each do |nominee_id|
      nominee_name = Player.find(nominee_id).name
      results[nominee_name] = []
    end

    submissions.each do |submission|
      nominator_name = Player.find(submission.nominator_id).name
      results[submission.nominee.name] << nominator_name
    end
    results.sort_by { |_nominee, nominators| -nominators.count }
  end

  private

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
