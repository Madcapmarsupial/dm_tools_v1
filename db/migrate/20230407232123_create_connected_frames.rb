class CreateConnectedFrames < ActiveRecord::Migration[7.0]
  def change
    create_table :connected_frames do |t|
      t.references :parent, foreign_key: {to_table: :frames}
      t.references :child, foreign_key: { to_table: :frames }
      
      t.timestamps
    end
  end
end
