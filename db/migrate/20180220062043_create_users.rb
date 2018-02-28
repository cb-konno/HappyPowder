class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :mail, null: false, limit: 100
      t.string :password , null: false, limit: 16
      t.string :name, null: false, limit: 50
      t.timestamp :created_at
      t.timestamp :updated_at
      t.boolean :is_deleted
    end
  end
end
