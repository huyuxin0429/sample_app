class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :contact_number
      # t.references :identifiable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
