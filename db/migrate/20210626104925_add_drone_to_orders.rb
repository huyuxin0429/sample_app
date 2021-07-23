class AddDroneToOrders < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :drone, null: true
  end
end
