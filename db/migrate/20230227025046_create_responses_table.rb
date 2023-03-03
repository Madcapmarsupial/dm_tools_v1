class CreateResponsesTable < ActiveRecord::Migration[7.0]
  def change
    create_table :responses do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.jsonb :completion, null: false
      t.text :prompt, default: "", null: false
      t.timestamps
    end   
  end
end
