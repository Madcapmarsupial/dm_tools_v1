class AddColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t| 
       t.datetime :current_sign_in_at
       t.datetime :last_sign_in_at
    end
  end
end
