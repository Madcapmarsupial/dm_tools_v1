class CreateJoinTables < ActiveRecord::Migration[7.0]
  def change
    create_join_table :roll_tables, :quests do |t|
      t.index :roll_table_id
      t.index :quest_id
    end

    create_join_table :roll_tables, :fields do |t|
      t.index :roll_table_id
      t.index :field_id
    end

  end
end
