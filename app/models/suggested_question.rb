# frozen_string_literal: true

# == Schema Information
#
# Table name: suggested_questions
#
#  id           :bigint           not null, primary key
#  processed_at :datetime
#  text         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class SuggestedQuestion < ApplicationRecord
  validates :text, presence: true

  def self.mark_as_processed(id)
    return nil if id.blank?

    SuggestedQuestion.find(id).touch(:processed_at)
  end
end
