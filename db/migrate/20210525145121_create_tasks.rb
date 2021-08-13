class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :category
      t.text :url

      t.timestamps
    end
    add_index :tasks, :category
  end
end
