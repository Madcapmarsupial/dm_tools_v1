class CreateDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :details do |t|
      t.string :label
      t.text :body 
      t.timestamps
    end
  end
end
