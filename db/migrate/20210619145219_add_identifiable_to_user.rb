class AddIdentifiableToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :identifiable, polymorphic: true
  end
end
