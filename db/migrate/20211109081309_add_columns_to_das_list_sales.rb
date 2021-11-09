class AddColumnsToDasListSales < ActiveRecord::Migration[6.1]
  def change
    add_column :das_list_sales, :twitter_list, :boolean, :default => true
    add_column :das_list_sales, :twitter_sale, :boolean, :default => true
  end
end
