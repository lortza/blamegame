# frozen_string_literal: true

class CreateAccomplishmentCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :accomplishment_categories do |t|
      t.references :accomplishment, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
