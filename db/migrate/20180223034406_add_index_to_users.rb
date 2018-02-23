class AddIndexToUsers < ActiveRecord::Migration[5.1]
  def up
    add_index :users, :name
    add_index :users, :mail
  end

  def down
    remove_index :users, :name
    remove_index :users, :mail
  end
end
