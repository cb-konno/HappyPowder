class AddColumnToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :remember_digest, :string
  end

  def down
    remove_column :users, :remember_digest
  end
end
