class CreateDrones < ActiveRecord::Migration[6.1]
  def change
    create_table :drones do |t|
      t.float :latitude
      t.float :longitude
      t.float :speed

      t.timestamps
    end
  end
end
