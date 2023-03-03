class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable

  after_create do 
    Account.create(owner_id: self.id)  
    self.account.credit(50)
  end

  #after_find :reward_user, if: :first_weekly_sign_in?


  has_many :quests,
  class_name: "Quest",
  dependent: :destroy

  has_one :account,
  class_name: "Account",
  foreign_key: :owner_id,
  primary_key: :id,
  dependent: :destroy

  has_many :responses,
  class_name: "Response",
  foreign_key: :user_id,
  primary_key: :id

  #--> login bottle_cap deposits

  #declare callback methods as protected or private. If left public,
   #they can be called from outside of the model and violate the principle of object encapsulation.

  #encrypts :id would need to switch it to a string
  def balance
    account.account_balance
  end

  def charge(cost=1)
    #usage = responses.last.total_usage
    
    account.debit(cost)
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


  def days_since_last_sign_in
    secs = (Time.now - self.last_sign_in_at.to_i)
    mins = (secs / 60)
    hours = (mins / 60)
    days = (hours / 24)
  end

  def age_of_users_account_in_weeks
    secs = (Time.now - self.created_at.to_i)
    mins = (secs / 60)
    hours = (mins / 60)
    days = (hours / 24)
    weeks_old = (days / 7)
  end



  def first_weekly_sign_in?

        #how many days old is your account?  we moduleo(%) that by 6
        #to make it account for the days of the week
        #when did you last sign in? 
        #user.find is gonna check (created_at) 
        # if the age of the account meets the weekly criteria.
        #and 

        #14 days % 6 
        # 2
        # signed 1 day ago


        #we need the first sign in of the week
        #whats the week?
        #we reward once every 7 days

        #rewards don't stack
        #














    #1.hour.to_i  # 3600
    #1.day        # ActiveSupport::Duration
    #3.days.ago   # ActiveSupport::TimeWithZone

    #Date.now
    #self.last_sign_in_at
    #self.current_sign_in_at  #7 = mon 14
    #self.created_at  #days_old % 7 == 0 reward

    # day of the week = account_age % 8 
    #  15 days % 7 = 1
    #

    # if the account is (7) days old 
    # reward the user
    #if he hasnt signed in since those 7 days have passed 

    #the account is 15 days old -> so two weeks

    # age of account = now - self.created_at
      # day_of_the_week = (day_counter % 6) 
      # reward if day_of_the_week > 0 
        # its a new week
        # how do we check if you have signed in this week?
        #if days_days_since_last_sign_in 
      #&& (days_since_last_sign_in > day_of_the_week)
  

    # if week_num < 7 
    #has the user signed in (week_num days)
        #since the beginning of the week?
    #yes no_reward

    #no reward


    #User.first.created_at.time.ago(1.week)
    
    # secs = (Time.now - self.created_at.to_i)
    # mins = (secs / 60)
    # hours = (mins / 60)
    # days = (hours / 24)
    # weeks_old = (days / 7)




# When a user creates an account, store the account creation timestamp in the database

# When a user signs in:
current_time = DateTime.now
signed_in_week_start = current_time - current_time.wday

if signed_in_week_start > created_at
  weeks_since_creation = ((signed_in_week_start - created_at).to_i / 7).to_i
  last_weeks_sign_in = last_sign_in_at ? ((last_sign_in_at - created_at).to_i / 7).to_i : -1

  if weeks_since_creation > last_weeks_sign_in
    # Perform the action if this is the first sign-in of the new week
    perform_action()
  end
end






  end

  def reward_user
    self.account.credit(10)
  end
end
