class AddIndexToUserRole < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :role
  end
end