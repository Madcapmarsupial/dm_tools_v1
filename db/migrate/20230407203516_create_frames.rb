class CreateFrames < ActiveRecord::Migration[7.0]
  def change
    create_table :frames do |t|
      t.string :name, null: true
      t.text :description, null: true
      t.string :goal, null: true
      t.string :obstacle, null: true
      t.string :danger, null: true
      t.references :field, foreign_key: { to_table: :fields }


      t.timestamps
    end
  end
end
