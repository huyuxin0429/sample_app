class AddStationEdgesJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :edges_stations, id: false do |t|
      t.belongs_to :station
      t.belongs_to :edge
    end
  end
end
