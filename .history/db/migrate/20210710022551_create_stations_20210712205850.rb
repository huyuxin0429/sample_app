class CreateStations < ActiveRecord::Migration[6.1]
  def change
    create_table :stations do |t|
      t.integer :provided_id, null: false
      t.timestamps
    end
  end
end
