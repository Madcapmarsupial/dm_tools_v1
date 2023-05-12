class ChangeRollTableLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :roll_tables, :link_type, :string
    add_column :roll_tables, :link_id, :integer, null: true
  end


end
