class EditTableDefualt < ActiveRecord::Migration[7.0]
  def change
    change_column_default(:roll_tables, :column_list, from: "name, occupation", to: "")
    change_column_default(:roll_tables, :completion, from: {"1"=>{"name"=>"Gerald", "occupation"=>"Blacksmith"}, "2"=>{"name"=>"Eleanor", "occupation"=>"Innkeeper"}}, to: {})

  end
end
