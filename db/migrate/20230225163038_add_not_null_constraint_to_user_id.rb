class AddNotNullConstraintToUserId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :quests, :user_id, false
  end
end
