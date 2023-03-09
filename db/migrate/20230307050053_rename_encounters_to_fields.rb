class RenameEncountersToFields < ActiveRecord::Migration[7.0]
  def change
    add_column :encounters, :type, :string, null: false
    rename_table('encounters', 'fields')
  end
end
