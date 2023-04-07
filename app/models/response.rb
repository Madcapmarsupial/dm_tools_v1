class Response < ApplicationRecord
  validate :is_parseable? 
  
  store_accessor :completion, [:usage, :choices] #

  after_save :charge_user
  
  #has_many :quests,
  #dependent: :destroy

    #pre req prompt
    # add a timer up top as pre req
    #layouts -> a timer should look like this 
    # a quest should look like this etc Quest.prereq  etc
    

  belongs_to :user,
  class_name: "User",
  foreign_key: :user_id,
  primary_key: :id,
  dependent: :destroy
 
  def self.build_response(prompt, user_id)
        response_values = completion_values(prompt, user_id)
          #create xscompletions and return the values in a hash 
        response = Response.new(response_values)
        if response.save #user charged only if validations are passed
          response
        else
          logger.info response.completion
          logger.error "#{response.errors.full_messages}"
          response
        end
  end

  def text_to_hash    
    begin
      #JSON.parse(self.choices.first['text']) # completion model
      JSON.parse(self.choices.first['message']['content']) #chat model
    rescue JSON::ParserError => e
      errors.add :completion, :not_parseable, message: "problem with the response with id=(#{self.id}). Check for: ':', '', and numerals, or check your prompt, the bot may be drifting out of bounds"
    rescue StandardError => e
      errors.add :base, :api_connection, message: "response was not generated"
    end
    #JSON.parse(self.choices.first['message']['content'])
  end

  def total_usage
    self.usage["total_tokens"]
  end

  private


  def self.completion_values(contextulized_prompt, user_id) 
    begin
      myBot = OpenAI::Client.new
      response = myBot.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [{ role: "user", content: contextulized_prompt}], # Required.
        temperature: 0.7,
      })
      #completion = myBot.completions(parameters: { model: "text-davinci-003", prompt: contextulized_prompt, max_tokens: 2000}) #completion
      values_hash = {user_id: user_id, prompt: contextulized_prompt, completion: response}
      #rescue OpenAI::Error::ServerError => e

      # temperature  number Optional Defaults to 1
      # What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
      # We generally recommend altering this or top_p but not both.
      # top_p  -> number Optional Defaults to 1
      # An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
      # We generally recommend altering this or temperature but not both.
      #What sampling temperature to use, between 0 and 2.
       # Higher values like 0.8 will make the output more random, 
       #while lower values like 0.2 will make it more focused and deterministic.
    
    rescue Net::OpenTimeout => e      
      raise e
    rescue Net::ReadTimeout => e
      raise e
    rescue StandardError => e
      raise e
    end
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


  def self.blank(user_hash)
    { "id"=>nil, 
      "model"=>"user_response",
      "usage"=>{
        "total_tokens"=>0,
        "prompt_tokens"=>0, 
        "completion_tokens"=>0}, 
      "choices"=> [ {"index"=>0, "message"=> {"role"=>"assistant","content"=>user_hash.to_json }, "finish_reason"=>"blank_stop"} ],
      "object"=>"blank_completion",
      "created"=>nil}
  end


end #class



# response = client.chat(
#     parameters: {
#         model: "gpt-3.5-turbo", # Required.
#         messages: [{ role: "user", content: "Hello!"}], # Required.
#         temperature: 0.7,
#     })

#choices.first["message"]["content"]
#response example
# {
#   "id": "chatcmpl-123",
#   "object": "chat.completion",
#   "created": 1677652288,
#   "choices": [
  #{  "index": 0,  "message": {
#       "role": "assistant",
#       "content": "\n\nHello there, how may I assist you today?",
#     },
#     "finish_reason": "stop"
#   }],
#   "usage": {
#     "prompt_tokens": 9,
#     "completion_tokens": 12,
#     "total_tokens": 21
#   }
# }


#your_client.models.list['data'].map { |model_hash| model_hash['id']}