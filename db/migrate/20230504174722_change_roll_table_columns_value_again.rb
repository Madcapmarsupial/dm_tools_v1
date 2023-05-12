class ChangeRollTableColumnsValueAgain < ActiveRecord::Migration[7.0]
  def change
    remove_column(:roll_tables, :column_list, type: :string, if_exists: true)
    add_column(:roll_tables, :column_count, :integer, default: 1, if_not_exists: true)
  end
end
