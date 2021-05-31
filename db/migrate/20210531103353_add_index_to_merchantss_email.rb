class AddIndexToMerchantssEmail < ActiveRecord::Migration[6.1]
  def change
    add_index :merchants, :email, unique: true
  end
end
