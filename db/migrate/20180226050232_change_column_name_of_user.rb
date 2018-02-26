class ChangeColumnNameOfUser < ActiveRecord::Migration[5.1]
  def up
    rename_column :users, :is_deleted, :deleted
  end

  def down
    rename_column :users, :deleted, :is_deleted
  end
end
