class DropExtraTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :traits
    drop_table :fields
    drop_table :encounter_responses
    drop_table :quest_responses
  end
end
