class AddIndexToAccounts < ActiveRecord::Migration[7.0]
  def change
     def up
    remove_index :accounts, :owner_id
    add_index :accounts, :owner_id, unique: true
  end

  def down
    remove_index :accounts, :owner_id
    add_index :accounts, :owner_id
  end
  end  
end
