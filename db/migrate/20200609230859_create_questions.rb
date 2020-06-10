class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :text
      t.boolean :family_friendly

      t.timestamps
    end
  end
end
