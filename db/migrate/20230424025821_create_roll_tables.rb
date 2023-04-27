class CreateRollTables < ActiveRecord::Migration[7.0]
  def change
    create_table :roll_tables do |t|
      t.string :table_type, null: false, default: "NPC"
      t.integer :row_count, null: false, default: 2
      t.string :column_list, null: false, default: "name, occupation"
      t.jsonb :completion, null: false, default: { "1": {"name": "Gerald", "occupation": "Blacksmith"}, "2": {"name": "Eleanor", "occupation": "Innkeeper"} }
      t.references :user
      t.timestamps
    end
  end
end
