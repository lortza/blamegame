class AddMaxRoundsToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :max_rounds, :integer
    add_column :games, :adult_content_permitted, :boolean, default: false
  end
end
