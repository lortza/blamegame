class AddArchivedToQuestionsTable < ActiveRecord::Migration[6.0]
  def up
    add_column :questions, :archived, :boolean, default: false
  end

  def down
    remove_column :questions, :archived
  end
end
