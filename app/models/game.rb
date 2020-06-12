class Game < ApplicationRecord
  MAX_ROUNDS = 3

  belongs_to :user
  has_many :players, inverse_of: :game, dependent: :destroy
  has_many :rounds, dependent: :destroy
  accepts_nested_attributes_for :players,
                                allow_destroy: true, # allows user to delete player via checkbox
                                reject_if: :all_blank # at least 1 player should be present
  before_create :generate_code

  scope :active, -> { where('created_at >= ? AND players_ready == ?', Time.zone.now, true) }
  # users.where(users[:name].eq('bob').or(users[:created_at].lt(1.day.ago)))

  def active?
    created_at.to_date >= Time.zone.now.to_date && players_ready?
  end

  def date
    created_at.strftime('%m-%d-%Y')
  end

  # def questions
  #   ::Question.all.sample(MAX_ROUNDS)
  # end


  def next_round
    this_round = round.number
    rounds.find_by(number: this_round + 1)
  end

  def generate_rounds
    round_numbers = (1..MAX_ROUNDS).to_a
    questions = ::Question.all.sample(MAX_ROUNDS)

    questions.each do |question|
      self.rounds.create!(
        number: round_numbers.shift,
        question_id: question.id
      )
    end
  end



  # TEMP methods to create fake relationships
  # def rounds
  #   %w[temp array until i build relationship]
  # end

  def submissions
    submission1 = OpenStruct.new(
      round: rounds.first,
      nominee: players.first,
      nominator: players.third
    )
    submission2 = OpenStruct.new(
      round: rounds.first,
      nominee: players.first,
      nominator: players.second
    )
    submission3 = OpenStruct.new(
      round: rounds.first,
      nominee: players.third,
      nominator: players.first
    )
    [submission1, submission2, submission3]
  end

  def generate_code
    letters = ('A'..'Z').to_a.shuffle
    self.code = ''
    4.times { self.code += letters.sample }
  end

end
