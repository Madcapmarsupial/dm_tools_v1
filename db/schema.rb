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

ActiveRecord::Schema[7.0].define(version: 2023_02_19_013138) do
  create_table "encounter_responses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "encounter_id", null: false
    t.text "full_response", null: false
    t.text "prompt", null: false
    t.index ["encounter_id"], name: "index_encounter_responses_on_encounter_id"
  end

  create_table "encounters", force: :cascade do |t|
    t.integer "quest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "name"
    t.index ["quest_id"], name: "index_encounters_on_quest_id"
  end

  create_table "fields", force: :cascade do |t|
    t.integer "quest_id"
    t.string "value"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["quest_id"], name: "index_fields_on_quest_id"
  end

  create_table "quest_responses", force: :cascade do |t|
    t.integer "quest_id", null: false
    t.text "response_text", null: false
    t.text "prompt", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quest_id"], name: "index_quest_responses_on_quest_id"
  end

  create_table "quests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "staged_response"
  end

  create_table "traits", force: :cascade do |t|
    t.integer "field_id"
    t.string "label"
    t.string "value"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "encounter_responses", "encounters"
  add_foreign_key "encounters", "quests"
  add_foreign_key "fields", "quests"
  add_foreign_key "quest_responses", "quests"
  add_foreign_key "traits", "fields"
end
