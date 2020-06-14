class Question < ApplicationRecord
  validates :text, presence: true
  has_many :rounds

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
