class ChangeColumnPasswordOfUsers < ActiveRecord::Migration[5.1]
  def up
    rename_column :users, :password, :password_digest
    change_column :users, :password_digest, :string, limit: 100
    add_column :users, :remember_token, :string, limit: 100
  end

  def down
    remove_column :users, :remember_token
    change_column :users, :password_digest, :string, limit: 16
    rename_column :users, :password_digest, :password
  end
end
