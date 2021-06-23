class AddMerchantReferenceToProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :products, :merchant
    add_index :products, [:name, :merchant_id], unique: true
  end
end
