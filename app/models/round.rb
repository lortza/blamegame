class Round < ApplicationRecord
  belongs_to :game
  belongs_to :question
  belongs_to :winner, class_name: 'Player', optional: true
  has_many :submissions

  def set_winner
    return unless all_votes_are_in?
    return if there_is_a_tie?

    winning_player_id = submissions_tally.first[0]
    self.update!(winner_id: winning_player_id)
  end

  def submissions_tally
    results = submissions.group(:nominee_id).count
    results.sort_by {|nominee, votes| -votes}
  end

  def there_is_a_tie?
    submissions_tally.first[1] == submissions_tally.second[1]
  end

  def all_votes_are_in?
    submissions.size == game.players.size
  end

  def results
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

    results
  end
end
