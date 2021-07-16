class CreateEdges < ActiveRecord::Migration[6.1]
  def change
    create_table :edges do |t|
      t.integer :src_id
      t.integer :dest_id
      t.float :cost


      t.timestamps
    end
  end
end
