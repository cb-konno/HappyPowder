class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description
      t.integer :priority
      t.integer :status
      t.datetime :started_at
      t.datetime :ended_at
      t.timestamp :created_at
      t.timestamp :updated_at
    end
  end
end
