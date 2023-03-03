class Response < ApplicationRecord
  validate :is_parseable? 
  
  store_accessor :completion, [:usage, :choices] #

  after_save :charge_user
  
  #has_many :quests,
  #dependent: :destroy

  belongs_to :user,
  class_name: "User",
  foreign_key: :user_id,
  primary_key: :id,
  dependent: :destroy
 
  def self.build_response(prompt, user_id)
      user = User.find_by(id: user_id)
      if user.has_enough_bottlecaps?  #check user balance
        response_values = completion_values(prompt, user.id)
          #create xscompletions and return the values in a hash 
        response = Response.new(response_values)
        if response.save #user charged only if validations are passed
          response
        else
          logger.error "#{response.errors.full_messages}"
          response
        end
      else
        raise  "error"
        #"insufficient funds"
      end
  end

  def text_to_hash    
    begin
      JSON.parse(self.choices.first['text'])
    rescue JSON::ParserError => e
      errors.add :completion, :not_parseable, message: "problem with the response with id=(#{self.id}). Check for: ':', '', and numerals, or check your prompt, the bot may be drifting out of bounds"
    end
    #JSON.parse(self.choices.first['message']['content'])
  end

  def total_usage
    self.usage["total_tokens"]
  end



  private
  def self.completion_values(contextulized_prompt, user_id) 
    #temp options
    #model options
    #etc
    myBot = OpenAI::Client.new
    completion = myBot.completions(parameters: { model: "text-davinci-003", prompt: contextulized_prompt, max_tokens: 2000}) 
    values_hash = {user_id: user_id, prompt: contextulized_prompt, completion: completion}
  end

  
  def charge_user
    #calculate cost usage 
    #cost must be based off quest and or the quests child_object context
    #users.last request x2 unless its their first request. ie a Quest 
    #cost = calc_cost(self.total_usage)
    user.charge(cost=1)
  end
 

  def is_parseable?
    begin
      if text_to_hash.is_a?(Hash) == false
        errors.add :completion, :not_a_hash, message: "the text was parsed but is not a hash?"
      else
        true
      end
    rescue JSON::ParserError => e
      errors.add :completion, :not_parseable, message: "problem with the response with id=(#{self.id}). Check for: ':', '', and numerals, or check your prompt, the bot may be drifting out of bounds"
    end
  end
  




end #class

