class Game < ApplicationRecord
  MAX_ROUNDS = 1

  belongs_to :user
  has_many :players, inverse_of: :game, dependent: :destroy
  has_many :rounds, dependent: :destroy
  accepts_nested_attributes_for :players,
                                allow_destroy: true, # allows user to delete player via checkbox
                                reject_if: :all_blank # at least 1 player should be present
  before_create :generate_code

  # scope :active, -> { where('created_at >= ? AND players_ready == ?', Time.zone.now, true) }
  # users.where(users[:name].eq('bob').or(users[:created_at].lt(1.day.ago)))

  def self.current
    hour_window = Time.zone.now - 3600

    where('created_at >= ?', hour_window)
  end

  def self.past
    hour_window = Time.zone.now - 3600
    where('created_at < ?', hour_window)
  end

  def activated?
    created_at.to_date >= Time.zone.now.to_date && players_ready?
  end

  def date
    created_at.strftime('%m-%d-%Y')
  end

  def next_round
    this_round = round.number
    rounds.find_by(number: this_round + 1)
  end

  def generate_rounds(adult_content_permitted)
    round_numbers = (1..MAX_ROUNDS).to_a
    questions = generate_questions(adult_content_permitted)

    questions.each do |question|
      self.rounds.create!(
        number: round_numbers.shift,
        question_id: question.id
      )
    end
  end

  def generate_questions(adult_content_permitted)
    if adult_content_permitted == 'true'
      ::Question.all.sample(MAX_ROUNDS)
    else
      ::Question.without_adult_content.sample(MAX_ROUNDS)
    end
  end

  def generate_code
    letters = ('A'..'Z').to_a.shuffle
    self.code = ''
    4.times { self.code += letters.sample }
  end


  def winner
    return unless all_rounds_are_complete?

    tally = tally_rounds
    return if there_is_a_tie?(tally)

    winning_player_id = tally.first[0]
    @winner ||= players.find(winning_player_id)
  end

  private

  def all_rounds_are_complete?
    rounds.map(&:complete?).uniq.first == true
  end

  def there_is_a_tie?(tally)
    return false if tally.size == 1

    tally.first[1] == tally.second[1]
  end

  def tally_rounds
    results = {}
    rounds.map do |round|
      if results[round.winner.id].present?
        results[round.winner.id] += 1
      else
        results[round.winner.id] = 1
      end
    end

    results.sort_by {|nominee, votes| -votes}
  end

end
