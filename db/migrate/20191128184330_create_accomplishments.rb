# frozen_string_literal: true

class CreateAccomplishments < ActiveRecord::Migration[6.0]
  def change
    create_table :accomplishments do |t|
      t.date :date, null: false
      t.text :description
      t.text :given_by
      t.references :accomplishment_type, null: false, foreign_key: true
      t.string :url
      t.boolean :bookmarked, default: false

      t.timestamps
    end
  end
end
