class RemoveTableRowsAndcolumns < ActiveRecord::Migration[7.0]
  def change
    drop_table :row_columns do |t|
      t.string "label"
      t.string "body"
      t.bigint "table_row_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["table_row_id"], name: "index_row_columns_on_table_row_id"
      t.foreign_key "table_rows"
    end

    drop_table :table_rows do |t|
      t.integer "row_num"
      t.bigint "roll_table_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.jsonb "data", default: {}
      t.index ["roll_table_id"], name: "index_table_rows_on_roll_table_id"
      t.index ["row_num"], name: "index_table_rows_on_row_num"
      t.foreign_key "roll_table"

    end
  end
end
