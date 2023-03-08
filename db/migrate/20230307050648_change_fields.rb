class ChangeFields < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:fields, :name, from: "untitled encounter", to: "untitled")
  end
end
