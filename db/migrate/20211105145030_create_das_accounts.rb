class CreateDasAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :das_accounts do |t|
      t.string :domain, uniq: true
      t.datetime :start_at
      t.integer :year
      t.datetime :end_at
      t.integer :depth
      t.string :invite_domain
      t.integer :invite_id
      t.string :discord_id
      t.timestamps
    end

    add_index :das_accounts, :invite_id

    create_table :das_list_sales do |t|
      t.string :domain
      t.integer :das_accoount_id
      t.boolean :is_list, default: true
      t.datetime :list_time
      t.decimal :list_price, precision: 20, scale: 3
      t.integer :list_ckb_price
      t.decimal :final_price, precision: 20, scale: 3
      t.integer :final_ckb_price
      t.string :list_discord_id
      t.string :sale_discord_id
      t.datetime :sale_time
      t.timestamps
    end

    add_index :das_list_sales, :is_list
    add_index :das_list_sales, :das_accoount_id

  end
end
