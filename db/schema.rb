# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180226084931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tasks", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "description", limit: 2000
    t.integer "priority"
    t.integer "status"
    t.date "started_on"
    t.date "ended_on"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "user_id"
    t.index ["name"], name: "index_tasks_on_name"
    t.index ["priority"], name: "index_tasks_on_priority"
    t.index ["status"], name: "index_tasks_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "mail", limit: 100, null: false
    t.string "password_digest", limit: 100, null: false
    t.string "name", limit: 50, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "deleted", default: false
    t.string "remember_token", limit: 100
    t.index ["mail"], name: "index_users_on_mail"
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "tasks", "users"
end
