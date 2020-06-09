# frozen_string_literal: true

class PostType < ApplicationRecord
  extend Sortable

  belongs_to :user
  has_many :posts, dependent: :destroy

  validates :name,
            presence: true,
            uniqueness: { scope: :user_id }

  def self.merit_or_praise
    raise_types = PostType.where('name ILIKE ? OR name ILIKE ?', '%merit%', '%praise%')
    where('post_type IN ?', raise_types)
  end
end
