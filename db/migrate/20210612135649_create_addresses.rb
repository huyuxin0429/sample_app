class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :street_address
      t.string :city
      t.string :country
      t.string :postcode
      t.string :building_no
      t.string :unit_number
      t.string :name
      # t.references :user, null: false, foreign_key: true
      t.references :addressable, polymorphic: true
      t.timestamps
    end
  end
end
