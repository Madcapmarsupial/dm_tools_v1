class RemoveNullQuesstResponseRequirement < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:quests, :response_id, true)

  end
end
