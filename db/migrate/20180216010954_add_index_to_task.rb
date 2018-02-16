class AddIndexToTask < ActiveRecord::Migration[5.1]
  def up
    add_index :tasks, :name
    add_index :tasks, :status
  end

  def down
    remove_index :tasks, :name
    remove_index :tasks, :status
  end
end
