class CreateAccountsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.references :owner, null: false, foreign_key: { to_table: :users }, unique: true
      t.decimal :account_balance, precision: 10, scale: 2, default: 0.0, null: false
      t.timestamps
    end
  end
end
