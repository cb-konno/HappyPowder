class AddUserIdToTasks < ActiveRecord::Migration[5.1]
  def up
    add_column :tasks, :user_id, :integer, after: :status
    add_foreign_key :tasks, :users
  end

  def down
    remove_foreign_key :tasks, :users
    remove_column :tasks, :user_id
  end
end
