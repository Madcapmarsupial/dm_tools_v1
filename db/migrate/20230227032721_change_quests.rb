class ChangeQuests < ActiveRecord::Migration[7.0]
  def change
    change_table :quests do  |t|
      t.jsonb :completion, null: true
      t.text :name, default: "untitled quest", null: false
      t.references :response, null: true, foreign_key: { to_table: :responses }
      t.remove :staged_response
    end

    change_table :encounters do |t|
      t.jsonb :completion, null: true
      t.references :response, null: true, foreign_key: { to_table: :responses }
    end

    change_column_default :encounters, :name, from: nil, to: "untitled encounter"

  end
end
