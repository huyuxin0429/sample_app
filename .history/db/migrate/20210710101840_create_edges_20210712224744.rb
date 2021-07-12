class CreateEdges < ActiveRecord::Migration[6.1]
  def change
    create_table :edges do |t|
      t.references :src, foreign_key: { to_table: :stations }
      t.references :dest, foreign_key: { to_table: :stations }
      t.float :cost


      t.timestamps
    end
  end
end
