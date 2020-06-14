class Game < ApplicationRecord
  MAX_ROUNDS = 1

  belongs_to :user
  has_many :players, inverse_of: :game, dependent: :destroy
  belongs_to :winner, class_name: 'Player', optional: true
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

  def set_winner
    return unless all_rounds_are_complete?
    return if there_is_a_tie?

    winning_player_id = rounds_tally.first[0]
    self.update!(winner_id: winning_player_id)
  end

  private

  def all_rounds_are_complete?
    rounds.size == rounds.pluck(:winner_id).uniq.compact.size
  end

  def there_is_a_tie?
    # WIP
    false
  end

  def rounds_tally
    results = rounds.group(:winner_id).count
    results.sort_by {|nominee, votes| -votes}
  end

end
