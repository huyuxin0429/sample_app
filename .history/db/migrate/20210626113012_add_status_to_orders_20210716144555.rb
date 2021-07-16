class AddStatusToOrders < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE TYPE order_status AS ENUM ('merchant_preparing', 'awaiting_drone_pickup', 'enroute_to_customer', 'awaiting_customer_pickup','completed');
    SQL

    add_column :orders, :status, :order_status, default: :awaiting_drone_pickup
    add_index :orders, :status
  end

  def down
    execute <<-SQL
      DROP TYPE order_status;
    SQL

    drop_column :orders, :status
  end
end
