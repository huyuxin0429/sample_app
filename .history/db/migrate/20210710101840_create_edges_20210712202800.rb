class CreateEdges < ActiveRecord::Migration[6.1]
  def change
    create_table :edges do |t|
      t.integer :src, foreign_key: { to_table: :addresses }
      t.integer :dest, foreign_key: { to_table: :addresses }
      t.float :cost


      t.timestamps
    end
  end
end
