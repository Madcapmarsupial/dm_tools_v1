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

ActiveRecord::Schema[7.0].define(version: 2023_03_30_233234) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.decimal "account_balance", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_accounts_on_owner_id", unique: true
  end

  create_table "components", force: :cascade do |t|
    t.bigint "field_id"
    t.string "type"
    t.string "alignment"
    t.jsonb "completion"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "response_id"
    t.integer "quantity"
    t.index ["field_id"], name: "index_components_on_field_id"
    t.index ["response_id"], name: "index_components_on_response_id"
  end

  create_table "fields", force: :cascade do |t|
    t.bigint "quest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "name", default: "untitled"
    t.jsonb "completion"
    t.bigint "response_id"
    t.string "type", null: false
    t.index ["quest_id"], name: "index_fields_on_quest_id"
    t.index ["response_id"], name: "index_fields_on_response_id"
  end

  create_table "quests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.jsonb "completion"
    t.text "name", default: "untitled quest", null: false
    t.bigint "response_id"
    t.index ["response_id"], name: "index_quests_on_response_id"
    t.index ["user_id"], name: "index_quests_on_user_id"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.jsonb "completion", null: false
    t.text "prompt", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.boolean "reward?", default: false
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.integer "sign_in_count", default: 0, null: false
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users", column: "owner_id"
  add_foreign_key "components", "fields"
  add_foreign_key "components", "responses"
  add_foreign_key "fields", "quests"
  add_foreign_key "fields", "responses"
  add_foreign_key "quests", "responses"
  add_foreign_key "quests", "users"
  add_foreign_key "responses", "users"
  add_foreign_key "transactions", "accounts"
end
