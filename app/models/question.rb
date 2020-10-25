# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id           :bigint           not null, primary key
#  adult_rating :boolean
#  archived     :boolean          default(FALSE)
#  text         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  deck_id      :bigint
#
# Indexes
#
#  index_questions_on_deck_id  (deck_id)
#
# Foreign Keys
#
#  fk_rails_...  (deck_id => decks.id)
#
class Question < ApplicationRecord
  belongs_to :deck
  has_many :rounds, dependent: :nullify
  validates :text, presence: true

  def self.active
    where(archived: false)
  end

  def self.search(field:, terms:)
    if terms.blank?
      active
    else
      where("#{field} ILIKE ?", "%#{terms}%")
    end
  end

  def self.without_adult_content
    active.where.not(adult_rating: true)
  end

  def active?
    archived == false
  end
end
