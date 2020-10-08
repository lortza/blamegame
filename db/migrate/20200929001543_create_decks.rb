class CreateDecks < ActiveRecord::Migration[6.0]
  def up
    create_table :decks do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_reference :questions, :deck, foreign_key: true
  end

  def down
    remove_reference :questions, :deck, index: true, foreign_key: true
    drop_table :decks
  end
end
