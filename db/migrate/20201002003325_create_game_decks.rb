class CreateGameDecks < ActiveRecord::Migration[6.0]
  def change
    create_table :game_decks do |t|
      t.references :game, null: false, foreign_key: true
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
