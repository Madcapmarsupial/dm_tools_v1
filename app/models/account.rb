class Account < ApplicationRecord
  #account has one owner 
  #owner has one account
  belongs_to :owner,
  class_name: 'User',
  foreign_key: :owner_id,
  primary_key: :id

  #validates :user, presence: true

  #transactions

  def debit(amnt)
    self.update(account_balance: self.account_balance -= amnt)
  end

  def credit(amnt)
    self.update(account_balance: self.account_balance += amnt)
  end

end