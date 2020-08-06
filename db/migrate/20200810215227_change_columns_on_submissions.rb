class ChangeColumnsOnSubmissions < ActiveRecord::Migration[6.0]
  def change
    rename_column :submissions, :nominee_id, :candidate_id
    rename_column :submissions, :nominator_id, :voter_id
  end
end
