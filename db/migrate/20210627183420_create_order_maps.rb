class CreateOrderMaps < ActiveRecord::Migration[6.1]
  def change
    create_table :order_maps do |t|
      t.string :words

      t.timestamps
    end
  end
end
