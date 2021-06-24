class AddAddressesToOrder < ActiveRecord::Migration[6.1]
  def change
    add_reference :orders, :pick_up_address, foreign_key: { to_table: :addresses }
    add_reference :orders, :drop_off_address, foreign_key: { to_table: :addresses }
  end
end
