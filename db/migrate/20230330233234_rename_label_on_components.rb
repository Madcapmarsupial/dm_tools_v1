class RenameLabelOnComponents < ActiveRecord::Migration[7.0]
  def change
    add_column :components, :quantity, :integer, null: true
    rename_column :components, :label, :name

  end
end
