class CreateSubmissions < ActiveRecord::Migration[6.0]
  def change
    create_table :submissions do |t|
      t.references :round, null: false, foreign_key: true
      t.references :nominee, references: :players, foreign_key: { to_table: :players }
      t.references :nominator, references: :players, foreign_key: { to_table: :players }

      t.timestamps
    end
  end
end
