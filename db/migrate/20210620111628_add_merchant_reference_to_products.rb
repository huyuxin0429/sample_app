class AddMerchantReferenceToProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :products, :merchants
  end
end