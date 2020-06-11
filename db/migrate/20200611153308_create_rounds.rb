class CreateRounds < ActiveRecord::Migration[6.0]
  def change
    create_table :rounds do |t|
      t.references :game, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.integer :number
      t.references :winner, references: :players, foreign_key: { to_table: :players }

      t.timestamps
    end
  end
end
