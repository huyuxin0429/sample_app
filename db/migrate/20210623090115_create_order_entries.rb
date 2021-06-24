class CreateOrderEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :order_entries do |t|
      t.references :product
      t.references :order
      t.integer :units_bought
      t.float :total_unit_price

      t.timestamps
    end
  end
end
