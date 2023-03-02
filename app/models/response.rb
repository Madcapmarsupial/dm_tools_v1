class Response < ApplicationRecord
  validate :is_parseable?   
  
  store_accessor :completion, [:usage, :choices] #
  
  #has_many :quests,
  #dependent: :destroy

  belongs_to :user,
  class_name: "User",
  foreign_key: :user_id,
  primary_key: :id,
  dependent: :destroy
 
  def self.create_response(prompt, user_id)
      user = User.find_by(id: user_id)
      if user.has_enough_bottlecaps?  #check user balance
        #tweak this method to pass in a error to Response to check at validation
          #thus no charge and no save
        v_hash = values_from_completion(prompt, user.id)
        #create a completions and return the values in a hash 
        response = Response.new(v_hash)
        if response.save  # <-- custom validations will be checked here
          user.charge(response.total_usage)  #$$$
          return response
        else
          #add to response errors and still return response?
          raise "#{response.errors.full_messages}" # response was not valid and was not saved
        end
      else
        raise  "error"
        #"insufficient funds"
      end
  end

  def text_to_hash
    JSON.parse(self.choices.first['text'])
    #JSON.parse(self.choices.first['message']['content'])
  end

  def total_usage
    self.usage["total_tokens"]
  end

 
  private
  def self.values_from_completion(contextulized_prompt, user_id) 
    

    myBot = OpenAI::Client.new
    completion = myBot.completions(parameters: { model: "text-davinci-003", prompt: contextulized_prompt, max_tokens: 2000}) 
    values_hash = {user_id: user_id, prompt: contextulized_prompt, completion: completion}
  end

  def craft_prompt(context, obj)
   # prompt = <<~EOT   pass in (context, obj)
    # context 
    # Your response should be in JSON format with #{obj.key_length} paramaters: obj.list_keys
    # {obj.list_specific_instructions
      # The "villain" parameter should hold 1 parameter: "name". 
      # The "encounter_list" parameter should be an array encounter names like [name_one, name_two]...
    # EOT
  end

  def is_parseable?
    # if (text_to_hash).is_a?(Hash) == false
    # self.errors[:base] << 'completion is not parsable, check your prompt format'
    #end
  end
end #class

