class CreateTableRows < ActiveRecord::Migration[7.0]
  def change
    create_table :table_rows do |t|
      t.integer :row_num, index: true
      t.references :roll_table, null: false, foreign_key: { to_table: :roll_tables }

      t.timestamps
    end
  end
end
