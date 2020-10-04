# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id           :bigint           not null, primary key
#  text         :string
#  adult_rating :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Question < ApplicationRecord
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
end
