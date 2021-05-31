class AddMerchantRememberDigestToMerchants < ActiveRecord::Migration[6.1]
  def change
    add_column :merchants, :merchant_remember_digest, :string
  end
end
