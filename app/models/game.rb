# frozen_string_literal: true

# == Schema Information
#
# Table name: games
#
#  id                      :bigint           not null, primary key
#  adult_content_permitted :boolean          default(FALSE)
#  code                    :string
#  max_rounds              :integer
#  players_ready           :boolean          default(FALSE)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :bigint           not null
#
# Indexes
#
#  index_games_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Game < ApplicationRecord
  DEFAULT_MAX_ROUNDS = 10

  belongs_to :user
  has_many :players, inverse_of: :game, dependent: :destroy
  has_many :rounds, dependent: :destroy
  has_many :game_decks, dependent: :destroy
  has_many :decks, through: :game_decks
  accepts_nested_attributes_for :players,
                                allow_destroy: true, # allows user to delete player via checkbox
                                reject_if: :all_blank # at least 1 player should be present
  before_create :generate_code

  validates :max_rounds,
            presence: true,
            numericality: { greater_than: 0 }

  def self.current
    where('created_at >= ?', 1.hour.ago)
  end

  def self.current_codes
    current.pluck(:code)
  end

  def self.past
    where('created_at < ?', 1.hour.ago)
  end

  def expired?
    if complete?
      rounds.last.submissions.last.created_at < 30.minutes.ago
    else
      created_over_2_hours_ago?
    end
  end

  def active?
    players_ready? && !expired?
  end

  def date
    created_at.strftime('%m-%d-%Y')
  end

  def generate_rounds
    available_questions = generate_questions
    rounds_count = available_questions.length < max_rounds ? available_questions.length : max_rounds
    round_numbers = (1..rounds_count).to_a

    available_questions.each do |question|
      rounds.create!(
        number: round_numbers.shift,
        question_id: question.id
      )
    end
  end

  def complete?
    complete_status = rounds.map(&:complete?).uniq
    complete_status.size == 1 && complete_status.first == true
  end

  def winner
    return unless complete?

    vote_results = votes_by_candidate
    return nil if no_rounds_have_a_winner?(vote_results)

    winning_player_id = vote_results.first[0]
    @winner ||= players.find(winning_player_id)
  end

  def tied?
    winner.blank?
  end

  def created_over_2_hours_ago?
    created_at <= 2.hours.ago
  end

  def submissions
    round_ids = rounds.pluck(:id)
    Submission.where(round_id: round_ids)
  end

  def total_rounds
    # max_rounds becomes inaccurate if it has been overridden
    # by a smaller number of available_questions.
    # this only works if game is in-play.
    rounds.length
  end

  private

  def generate_code
    acceptable_letters = ('A'..'Z').to_a - %w[O I]
    letters = acceptable_letters.shuffle
    self.code = ''
    4.times { self.code += letters.sample }
  end

  def generate_questions
    base_questions = ::Question.active.where(deck_id: deck_ids)

    if adult_content_permitted?
      base_questions.sample(max_rounds)
    else
      base_questions.without_adult_content.sample(max_rounds)
    end
  end

  def no_rounds_have_a_winner?(vote_results)
    return true if (vote_results == []) || there_is_a_tie?(vote_results)
  end

  def there_is_a_tie?(vote_results)
    return false if vote_results.size == 1

    vote_results.first[1] == vote_results.second[1]
  end

  def votes_by_candidate
    results = {}
    rounds_with_winners.each do |round|
      if results[round.winner.id].present?
        results[round.winner.id] += 1
      else
        results[round.winner.id] = 1
      end
    end

    results.sort_by { |_candidate, votes| -votes }
  end

  def rounds_with_winners
    rounds.select { |round| round.winner.present? }.compact
  end
end
