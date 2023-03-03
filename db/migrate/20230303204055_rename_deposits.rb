class RenameDeposits < ActiveRecord::Migration[7.0]
  def change
    rename_table('deposits', 'transactions')
  end
end
