class AddMrememberDigestToMerchant < ActiveRecord::Migration[6.1]
  def change
    add_column :merchants, :mremember_digest, :string
  end
end
