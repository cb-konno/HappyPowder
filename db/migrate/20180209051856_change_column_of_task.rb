class ChangeColumnOfTask < ActiveRecord::Migration[5.1]
  def up
    change_column :tasks, :name, :string, null: false, limit: 50
    change_column :tasks, :description, :string, limit: 400
  end

  def down
    change_column :tasks, :name, :string, null: true, limit: 255
    change_column :tasks, :description, :text
  end
end
