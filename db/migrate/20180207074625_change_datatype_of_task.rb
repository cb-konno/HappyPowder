class ChangeDatatypeOfTask < ActiveRecord::Migration[5.1]
  def up
    change_column :tasks, :started_at, :date
    change_column :tasks, :ended_at, :date
  end

  def down
    change_column :tasks, :started_at, :datetime
    change_column :tasks, :ended_at, :datetime
  end
end
