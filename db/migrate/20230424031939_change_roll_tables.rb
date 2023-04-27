class ChangeRollTables < ActiveRecord::Migration[7.0]
  def change
    add_reference :roll_tables, :response, null: true, foreign_key: :true
  end
end
