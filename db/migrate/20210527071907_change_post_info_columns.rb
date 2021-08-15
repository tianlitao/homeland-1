class ChangePostInfoColumns < ActiveRecord::Migration[6.1]
  def change
    rename_column :post_infos, :topic_id, :post_id
    add_column :posts, :category, :string
    add_index :posts, :category
  end
end
