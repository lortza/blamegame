class Game < ApplicationRecord
  DEFAULT_MAX_ROUNDS = 10

  belongs_to :user
  has_many :players, inverse_of: :game, dependent: :destroy
  has_many :rounds, dependent: :destroy
  accepts_nested_attributes_for :players,
                                allow_destroy: true, # allows user to delete player via checkbox
                                reject_if: :all_blank # at least 1 player should be present
  before_create :generate_code

  def self.current
    where('created_at >= ?', 1.hour.ago)
  end

  def self.past
    where('created_at < ?', 1.hour.ago)
  end

  def expired?
    if complete?
      rounds.last.submissions.last.created_at < 30.minutes.ago
    else
      created_at < 2.hours.ago
    end
  end

  def activated?
    created_at.to_date >= Time.zone.now.to_date && players_ready?
  end

  def date
    created_at.strftime('%m-%d-%Y')
  end

  def generate_rounds
    round_numbers = (1..max_rounds).to_a
    questions = generate_questions

    questions.each do |question|
      self.rounds.create!(
        number: round_numbers.shift,
        question_id: question.id
      )
    end
  end

  def complete?
    rounds.map(&:complete?).uniq.first == true
  end

  def winner
    return unless complete?

    vote_results = votes_by_nominee
    return if no_rounds_have_a_winner?(vote_results)

    winning_player_id = vote_results.first[0]
    @winner ||= players.find(winning_player_id)
  end

  private

  def generate_code
    letters = ('A'..'Z').to_a.shuffle
    self.code = ''
    4.times { self.code += letters.sample }
  end

  def generate_questions
    if adult_content_permitted?
      ::Question.all.sample(max_rounds)
    else
      ::Question.without_adult_content.sample(max_rounds)
    end
  end


  def no_rounds_have_a_winner?(vote_results)
    return true if (vote_results == []) || (there_is_a_tie?(vote_results))
  end

  def there_is_a_tie?(vote_results)
    return false if vote_results.size == 1

    vote_results.first[1] == vote_results.second[1]
  end

  def votes_by_nominee
    results = {}
    rounds_with_winners.each do |round|
      if results[round.winner.id].present?
        results[round.winner.id] += 1
      else
        results[round.winner.id] = 1
      end
    end

    results.sort_by {|nominee, votes| -votes}
  end

  def rounds_with_winners
    rounds.select { |round| round.winner.present? }.compact
  end
end
