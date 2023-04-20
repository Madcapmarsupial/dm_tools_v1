class AddDefualtValues < ActiveRecord::Migration[7.0]
  def change
    change_column_default :quests, :completion, from: nil, to: {}
    change_column_default :fields, :completion, from: nil, to: {}
    change_column_default :components, :completion, from: nil, to: {}
  end
end
