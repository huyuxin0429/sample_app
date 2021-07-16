class CreateEdges < ActiveRecord::Migration[6.1]
  def change
    create_table :edges do |t|
      t.integer :provided_src_id
      t.references :provided_dest_id
      t.float :cost


      t.timestamps
    end
  end
end
