class ChangeRollTablesUsers < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :roll_tables, :users
    remove_foreign_key :roll_tables, :responses
  end
end
