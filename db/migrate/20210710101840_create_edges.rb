class CreateEdges < ActiveRecord::Migration[6.1]
  def change
    create_table :edges do |t|

      t.timestamps
    end
  end
end
