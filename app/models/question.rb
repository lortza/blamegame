# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :rounds
  validates :text, presence: true

  def self.search(field:, terms:)
    if terms.blank?
      all
    else
      where("#{field} ILIKE ?", "%#{terms}%")
    end
  end

  def self.without_adult_content
    where.not(adult_rating: true)
  end
end
