class AddUserIdToQuests < ActiveRecord::Migration[7.0]
  def change
    add_reference :quests, :user, foreign_key: true   
  end
end
