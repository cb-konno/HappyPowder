class ChangeDatatypeOfTask < ActiveRecord::Migration[5.1]
  def up
    rename_column :tasks, :started_at, :started_on
    rename_column :tasks, :ended_at, :ended_on
    change_column :tasks, :started_on, :date
    change_column :tasks, :ended_on, :date
  end

  def down
    rename_column :tasks, :started_on, :started_at
    rename_column :tasks, :ended_on, :ended_at
    change_column :tasks, :started_at, :datetime
    change_column :tasks, :ended_at, :datetime
  end
end
