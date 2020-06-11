class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.references :user, null: false, foreign_key: true
      t.string :code
      t.boolean :players_ready, default: false

      t.timestamps
    end
  end
end
