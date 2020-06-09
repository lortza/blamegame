class RemoveImageUrlFieldFromPosts < ActiveRecord::Migration[6.0]
  def up
    remove_column :posts, :image_url
  end

  def down
    add_column :posts, :image_url, :string
  end
end
