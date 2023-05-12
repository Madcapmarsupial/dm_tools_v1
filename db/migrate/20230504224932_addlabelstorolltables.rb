class Addlabelstorolltables < ActiveRecord::Migration[7.0]
  def change
    add_column(:table_rows, :data, :jsonb, default: {}, if_not_exists: true)

  end
end
