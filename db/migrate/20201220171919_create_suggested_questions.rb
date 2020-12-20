class CreateSuggestedQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :suggested_questions do |t|
      t.string :text
      t.datetime :processed_at

      t.timestamps
    end
  end
end
