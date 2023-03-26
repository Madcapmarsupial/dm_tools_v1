class ChangeNullOnFields < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:fields, :quest_id, true)
  end
end
