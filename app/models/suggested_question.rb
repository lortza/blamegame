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
end
