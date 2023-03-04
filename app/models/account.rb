class Account < ApplicationRecord
  #account has one owner 
  #owner has one account
  has_many :transactions

  belongs_to :owner,
  class_name: 'User',
  foreign_key: :owner_id,
  primary_key: :id

  def debit(amnt)
    self.update(account_balance: self.account_balance -= amnt)
    #add a type column for charge or debit
    Transaction.create(amount: -amnt, account_id: self.id)
  end

  def credit(amnt)
    self.update(account_balance: self.account_balance += amnt)
    Transaction.create( amount: amnt, account_id: self.id)
  end
end