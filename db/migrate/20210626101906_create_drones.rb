class CreateDrones < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE TYPE drone_status AS ENUM ('free_stationary', 'free_moving', 'heading_to_pickup', 'waiting_for_pickup','heading_to_drop_off', 'waiting_for_drop_off');
    SQL
    create_table :drones do |t|
      # t.string :full_address
      # t.decimal :latitude
      # t.decimal :longitude
      t.decimal :speed
      t.references :destination_address, foreign_key: { to_table: :addresses }, optional: true
      t.timestamps
    end
    add_column :drones, :status, :drone_status, default: :free_stationary
    # add_index :drones, [:latitude, :longitude]
    add_index :drones, :status
  end

  def down
    drop_table :drones
    execute <<-SQL
      DROP TYPE drone_status;
    SQL
  end

end
