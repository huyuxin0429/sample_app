class AddIntermediateRouteToDrone < ActiveRecord::Migration[6.1]
  def change
    add_column  :drone, :address_id_route, :integer, array: true, default: []
  end
end
