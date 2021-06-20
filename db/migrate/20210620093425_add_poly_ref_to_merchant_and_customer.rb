class AddPolyRefToMerchantAndCustomer < ActiveRecord::Migration[6.1]
  def change
    add_reference :customers, :identifiable
    add_reference :merchants, :identifiable
  end
end
