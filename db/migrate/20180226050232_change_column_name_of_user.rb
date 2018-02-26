class ChangeColumnNameOfUser < ActiveRecord::Migration[5.1]
  def up
    rename_column :users, :is_deleted, :deleted
    change_column_default :users, :deleted, false
  end

  def down
    change_column_default :users, :deleted, nil
    rename_column :users, :deleted, :is_deleted
  end
end
