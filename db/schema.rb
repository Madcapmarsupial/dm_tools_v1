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

ActiveRecord::Schema[7.0].define(version: 2023_05_12_181536) do
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
    t.string "component_alignment"
    t.jsonb "completion", default: {}
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "response_id"
    t.integer "quantity"
    t.string "desc", default: "", null: false
    t.index ["field_id"], name: "index_components_on_field_id"
    t.index ["response_id"], name: "index_components_on_response_id"
  end

  create_table "connected_details", force: :cascade do |t|
    t.bigint "parent_detail_id"
    t.bigint "child_detail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_detail_id"], name: "index_connected_details_on_child_detail_id"
    t.index ["parent_detail_id"], name: "index_connected_details_on_parent_detail_id"
  end

  create_table "connected_frames", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "child_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_connected_frames_on_child_id"
    t.index ["parent_id"], name: "index_connected_frames_on_parent_id"
  end

  create_table "details", force: :cascade do |t|
    t.string "label"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fields", force: :cascade do |t|
    t.bigint "quest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "name", default: "untitled"
    t.jsonb "completion", default: {}
    t.bigint "response_id"
    t.string "type", null: false
    t.index ["quest_id"], name: "index_fields_on_quest_id"
    t.index ["response_id"], name: "index_fields_on_response_id"
  end

  create_table "fields_roll_tables", id: false, force: :cascade do |t|
    t.bigint "roll_table_id", null: false
    t.bigint "field_id", null: false
    t.index ["field_id"], name: "index_fields_roll_tables_on_field_id"
    t.index ["roll_table_id"], name: "index_fields_roll_tables_on_roll_table_id"
  end

  create_table "frames", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "goal"
    t.string "obstacle"
    t.string "danger"
    t.bigint "field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field_id"], name: "index_frames_on_field_id"
  end

  create_table "quest_details", id: false, force: :cascade do |t|
    t.bigint "detail_id", null: false
    t.bigint "quest_id", null: false
    t.index ["detail_id", "quest_id"], name: "index_quest_details_on_detail_id_and_quest_id"
    t.index ["quest_id", "detail_id"], name: "index_quest_details_on_quest_id_and_detail_id"
  end

  create_table "quests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.jsonb "completion", default: {}
    t.text "name", default: "untitled quest", null: false
    t.bigint "response_id"
    t.text "notes"
    t.string "rules"
    t.string "recap_intros"
    t.string "opening"
    t.index ["response_id"], name: "index_quests_on_response_id"
    t.index ["user_id"], name: "index_quests_on_user_id"
  end

  create_table "quests_roll_tables", id: false, force: :cascade do |t|
    t.bigint "roll_table_id", null: false
    t.bigint "quest_id", null: false
    t.index ["quest_id"], name: "index_quests_roll_tables_on_quest_id"
    t.index ["roll_table_id"], name: "index_quests_roll_tables_on_roll_table_id"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.jsonb "completion", null: false
    t.text "prompt", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "roll_tables", force: :cascade do |t|
    t.string "table_type", default: "NPC", null: false
    t.integer "row_count", default: 2, null: false
    t.jsonb "completion", default: {}, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "response_id"
    t.integer "column_count", default: 1
    t.text "context", default: "", null: false
    t.string "link_type"
    t.integer "link_id"
    t.index ["link_id"], name: "index_roll_tables_on_link_id"
    t.index ["response_id"], name: "index_roll_tables_on_response_id"
    t.index ["user_id"], name: "index_roll_tables_on_user_id"
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
  add_foreign_key "connected_details", "details", column: "child_detail_id"
  add_foreign_key "connected_details", "details", column: "parent_detail_id"
  add_foreign_key "connected_frames", "frames", column: "child_id"
  add_foreign_key "connected_frames", "frames", column: "parent_id"
  add_foreign_key "fields", "quests"
  add_foreign_key "fields", "responses"
  add_foreign_key "frames", "fields"
  add_foreign_key "quests", "responses"
  add_foreign_key "quests", "users"
  add_foreign_key "responses", "users"
  add_foreign_key "roll_tables", "users"
  add_foreign_key "transactions", "accounts"
end
