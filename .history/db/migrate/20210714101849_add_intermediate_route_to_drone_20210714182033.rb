class AddIntermediateRouteToDrone < ActiveRecord::Migration[6.1]
  def change
    add_integer :address_id_route, :drone, array: true
  end
end
