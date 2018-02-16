class AddIndexToPriorityOfTask < ActiveRecord::Migration[5.1]
  def up
    add_index :tasks, :priority
  end

  def down
    remove_index :tasks, :priority
  end
end
