class Question < ApplicationRecord
  validates :text, presence: true
end
