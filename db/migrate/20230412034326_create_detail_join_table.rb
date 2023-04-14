class CreateDetailJoinTable < ActiveRecord::Migration[7.0]
  def change
     create_table :connected_details do |t|
      t.references :parent_detail, foreign_key: {to_table: :details}
      t.references :child_detail, foreign_key: { to_table: :details }
      
      t.timestamps 
    end
  end
end
