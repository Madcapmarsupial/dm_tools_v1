class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable

  has_many :quests,
  class_name: "Quest",
  dependent: :destroy

  has_one :account,
  class_name: "Account",
  foreign_key: :owner_id,
  primary_key: :id,
  dependent: :destroy

  #encrypts :id would need to switch it to a string

  def balance
    account.account_balance
  end

end
