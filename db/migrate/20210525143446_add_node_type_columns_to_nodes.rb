class AddNodeTypeColumnsToNodes < ActiveRecord::Migration[6.1]
  def change
    add_column :nodes, :node_type, :string, :default => 'Post'
    add_column :topics, :node_type, :string, :default => 'Post'
    add_index :nodes, :node_type
    add_index :topics, :node_type
  end
end
