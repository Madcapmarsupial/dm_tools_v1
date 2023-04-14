class RenameDetailsQuests < ActiveRecord::Migration[7.0]
  def change
    rename_table("details_quests", "quest_details") 
  end
end
