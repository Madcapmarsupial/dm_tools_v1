class AddUniqueIndexToAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_index :accounts, :owner_id
    add_index :accounts, :owner_id, unique: true
  end
end
