class Transaction < ApplicationRecord
  belongs_to :account
end
#add a callumn to see if its a charge or credit