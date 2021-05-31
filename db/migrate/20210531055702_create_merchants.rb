class CreateMerchants < ActiveRecord::Migration[6.1]
  def change
    create_table :merchants do |t|
      t.string :company_name
      t.string :email
      t.text :address
      t.integer :contact_no

      t.timestamps
    end
  end
end
