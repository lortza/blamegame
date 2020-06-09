class RenameAccomplishments < ActiveRecord::Migration[6.0]
  def up
    rename_table :accomplishments, :posts
    rename_table :accomplishment_categories, :post_categories
    rename_table :accomplishment_types, :post_types

    rename_column :posts, :accomplishment_type_id, :post_type_id
    rename_column :post_categories, :accomplishment_id, :post_id
  end

  def down
    rename_table :posts, :accomplishments
    rename_table :post_categories, :accomplishment_categories
    rename_table :post_types, :accomplishment_types

    rename_column :accomplishments, :post_type_id, :accomplishment_type_id
    rename_column :accomplishment_categories, :post_id, :accomplishment_id
  end
end
