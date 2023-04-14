class AddColumnsToQuests < ActiveRecord::Migration[7.0]
  def change
    add_column :quests, :tone, :string, null: :true
    add_column :quests, :rules, :string, null: :true
    add_column :quests, :recap_intros, :string, null: :true
    add_column :quests, :opening, :string, null: :true
  end
end
