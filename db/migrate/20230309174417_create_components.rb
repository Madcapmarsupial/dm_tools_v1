class CreateComponents < ActiveRecord::Migration[7.0]
  def change
    create_table :components do |t|
      t.references :field, foreign_key: { to_table: :fields }
      t.string :type
      t.string :alignement
      t.jsonb :completion
      t.string :label
      t.timestamps
    end
  end
end
