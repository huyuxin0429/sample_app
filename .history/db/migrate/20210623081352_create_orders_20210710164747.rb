class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :customer
      # t.references :merchant
      t.float :total_price

      t.timestamps
    end
    add_index :orders, [:customer_id, :created_at]
    add_index :orders, [:merchant_id, :created_at]
    add_index :orders, [:merchant_id, :customer_id]
  end
end
