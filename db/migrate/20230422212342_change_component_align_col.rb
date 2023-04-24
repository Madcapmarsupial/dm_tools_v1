class ChangeComponentAlignCol < ActiveRecord::Migration[7.0]
  def change
    rename_column :components, :alignment, :component_alignment
  end
end
