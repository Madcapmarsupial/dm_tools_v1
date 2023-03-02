class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable

  after_create do 
    Account.create(owner_id: self.id)  
  end

  has_many :quests,
  class_name: "Quest",
  dependent: :destroy

  has_one :account,
  class_name: "Account",
  foreign_key: :owner_id,
  primary_key: :id,
  dependent: :destroy

  #--> login bottle_cap deposits

  #declare callback methods as protected or private. If left public,
   #they can be called from outside of the model and violate the principle of object encapsulation.

  #encrypts :id would need to switch it to a string
  def balance
    account.account_balance
  end

  def charge(usage)
    #calculate cost usage 
    #cost must be based off quest and or the quests child_object context
    #users.last request x2 unless its their first request. ie a Quest 
    account.debit(cost=1)
  end

  def has_enough_bottlecaps?
    balance > 1 ? true : false
  end
  #sign_in_count - Increased every time a sign in is made (by form, openid, oauth)
  #current_sign_in_at - A timestamp updated when the user signs in
  #last_sign_in_at - Holds the timestamp of the previous sign in
  #current_sign_in_ip - The remote ip updated when the user sign in
  #last_sign_in_ip - Holds the remote ip of the previous sign in
  private
end
