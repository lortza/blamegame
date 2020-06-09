class AddImageUrlToAccomplishments < ActiveRecord::Migration[6.0]
  def change
    add_column :accomplishments, :image_url, :string
  end
end
