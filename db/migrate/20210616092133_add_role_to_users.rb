class AddRoleToUsers < ActiveRecord::Migration[6.1]

  def up
    execute <<-SQL
      CREATE TYPE role_position AS ENUM ('customer', 'merchant', 'not_set');
    SQL
    add_column :users, :role, :role_position, default: 'customer'
  end

  def down
    remove_column :users, :role
    execute <<-SQL
      DROP TYPE role;
    SQL
  end
end
