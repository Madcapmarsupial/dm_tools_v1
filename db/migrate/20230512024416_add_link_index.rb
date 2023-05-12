class AddLinkIndex < ActiveRecord::Migration[7.0]
  def change
    add_index(:roll_tables, :link_id)
  end
end
