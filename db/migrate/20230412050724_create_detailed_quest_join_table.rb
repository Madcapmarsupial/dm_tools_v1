class CreateDetailedQuestJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :details, :quests do |t|
       t.index [:detail_id, :quest_id]
       t.index [:quest_id, :detail_id]
    end
  end
end
