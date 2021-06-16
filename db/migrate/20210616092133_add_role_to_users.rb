class AddRoleToUsers < ActiveRecord::Migration[6.1]

  def up
    execute <<-SQL
      CREATE TYPE role AS ENUM ('user', 'merchant');
    SQL
    add_column :users, :role, :integer, default: 'user'
  end

  def down
    add_column :users, :role
    execute <<-SQL
      DROP TYPE role;
    SQL
  end
end
