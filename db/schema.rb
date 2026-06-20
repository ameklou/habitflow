# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_12_093736) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string "condition_type", null: false
    t.integer "condition_value", default: 1, null: false
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.string "icon"
    t.string "key", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_type"], name: "index_achievements_on_condition_type"
    t.index ["key"], name: "index_achievements_on_key", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "color"
    t.datetime "created_at", null: false
    t.string "icon"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id", "name"], name: "index_categories_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "habit_completions", force: :cascade do |t|
    t.date "completed_on", null: false
    t.integer "count", default: 1, null: false
    t.datetime "created_at", null: false
    t.bigint "habit_id", null: false
    t.text "note"
    t.datetime "updated_at", null: false
    t.index ["completed_on"], name: "index_habit_completions_on_completed_on"
    t.index ["habit_id", "completed_on"], name: "index_habit_completions_on_habit_id_and_completed_on", unique: true
    t.index ["habit_id"], name: "index_habit_completions_on_habit_id"
  end

  create_table "habits", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "archived_at"
    t.bigint "category_id"
    t.string "color"
    t.datetime "created_at", null: false
    t.integer "days_of_week", default: [], null: false, array: true
    t.text "description"
    t.string "frequency", default: "daily", null: false
    t.integer "goal_count", default: 1, null: false
    t.string "icon"
    t.string "name", null: false
    t.time "reminder_time"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["category_id"], name: "index_habits_on_category_id"
    t.index ["user_id", "active"], name: "index_habits_on_user_id_and_active"
    t.index ["user_id", "archived_at"], name: "index_habits_on_user_id_and_archived_at"
    t.index ["user_id"], name: "index_habits_on_user_id"
  end

  create_table "reminders", force: :cascade do |t|
    t.string "channel", default: "email", null: false
    t.datetime "created_at", null: false
    t.integer "days_of_week", default: [], null: false, array: true
    t.boolean "enabled", default: true, null: false
    t.bigint "habit_id", null: false
    t.time "reminder_time", null: false
    t.datetime "updated_at", null: false
    t.index ["habit_id", "enabled"], name: "index_reminders_on_habit_id_and_enabled"
    t.index ["habit_id"], name: "index_reminders_on_habit_id"
    t.index ["reminder_time"], name: "index_reminders_on_reminder_time"
  end

  create_table "user_achievements", force: :cascade do |t|
    t.bigint "achievement_id", null: false
    t.datetime "created_at", null: false
    t.datetime "unlocked_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["achievement_id"], name: "index_user_achievements_on_achievement_id"
    t.index ["user_id", "achievement_id"], name: "index_user_achievements_on_user_id_and_achievement_id", unique: true
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.jsonb "notification_preferences", default: {}, null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "standard", null: false
    t.string "timezone", default: "UTC", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "categories", "users"
  add_foreign_key "habit_completions", "habits"
  add_foreign_key "habits", "categories"
  add_foreign_key "habits", "users"
  add_foreign_key "reminders", "habits"
  add_foreign_key "user_achievements", "achievements"
  add_foreign_key "user_achievements", "users"
end
