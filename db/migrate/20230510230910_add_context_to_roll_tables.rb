class AddContextToRollTables < ActiveRecord::Migration[7.0]
  def change
    add_column :roll_tables, :context, :text, null: false, default: "" 
  end
end
