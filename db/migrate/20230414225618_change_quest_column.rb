class ChangeQuestColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :quests, :tone, :text
    rename_column :quests, :tone, :notes 
  end
end
