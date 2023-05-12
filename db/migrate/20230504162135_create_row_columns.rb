class CreateRowColumns < ActiveRecord::Migration[7.0]
  def change
    create_table :row_columns do |t|
      t.string :label
      t.string :body
      t.references :table_row, null: false, foreign_key: { to_table: :table_rows }


      t.timestamps
    end
  end
end
