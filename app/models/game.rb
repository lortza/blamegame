class Game < ApplicationRecord
  belongs_to :user

  has_many :players, inverse_of: :game, dependent: :destroy
  accepts_nested_attributes_for :players,
                                reject_if: :all_blank, # at least 1 player should be present
                                allow_destroy: true # allows user to delete player via checkbox

  MAX_ROUNDS = 2

  def date
    created_at.strftime('%m-%d-%Y')
  end

  def questions
    ::Question.all.sample(MAX_ROUNDS)
  end
end
