class CreateDepositsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :deposits do |t|
      t.decimal :amount, precision: 10, scale: 2, default: 0.0, null: false
      t.boolean :reward?, default: false
      t.references :account, null: false, foreign_key: { to_table: :accounts }
      t.timestamps 
    end
  end
end
