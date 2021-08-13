class CreatePostInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :post_infos do |t|
      t.integer :topic_id
      t.string :url
      t.string :uuid
      t.string :task_category
      t.string :author
      t.datetime :published_at

      t.timestamps
    end
    add_index :post_infos, :topic_id
    add_index :post_infos, [:uuid, :task_category], unique: true
  end
end
