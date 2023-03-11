class RenameComponentCol < ActiveRecord::Migration[7.0]
  def change
    rename_column(:components, :alignement, :alignment)
  end
end
