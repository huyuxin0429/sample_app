class AddIntermediateRouteToDrone < ActiveRecord::Migration[6.1]
  def change
    add_column :drones, :address_id_route, :integer, array: true, default: []
    # add_column :users, :reset_sent_at, :datetime
  end
end
