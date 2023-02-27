class QuestResponse < ApplicationRecord
  # validates: :response_text, :prescence true
  # validates: :prompt, :prescence true
  # validates: :response_is_valid, 

  belongs_to :quest,
  primary_key: :id,
  foreign_key: :quest_id

  # def return_text    
  #   text = JSON.parse(response_text)["choices"][0]["text"]
  # end
 
  # def text_to_hash
  #   JSON.parse(staged_response)
  # end

  #  def get(element)
  #    self.text_to_hash[element]
  #  end

  # def encounters_array
  #   self.text_to_hash["encounter_list"]
  # end

  # def get_encounter(name)
  #   #{'encounter_name' => name}
  #   index = encounters_array.find_index(name)
  #   encounters_array[index]
  # end

  #quest action?
  def create_new_quest_response_from_staged
    edited = JSON.parse(self.response_text)
    edited["choices"][0]["text"] = self.quest.staged_response

    QuestResponse.create(quest_id: self.quest_id, prompt: self.prompt, response_text: edited.to_json)
  end
end



#myBot = OpenAI::Client.new
# response = myBot.completions 
  #(
    #parameters: { model: "text-davinci-003", prompt: "Once upon a time", max_tokens: 5}
  #)

  # response = myBot.completions(parameters: { model: "text-davinci-003", prompt: "Once upon a time", max_tokens: 5})

#API Response HTTP::party
#   {"id"=>"cmpl-6iZWIXxJhTI3QoDIIUibqjG3wu53M",
#  "object"=>"text_completion",
#  "created"=>1676080990,
#  "model"=>"text-davinci-003",
#  "choices"=>[{"text"=>", there was a small", "index"=>0, "logprobs"=>nil, "finish_reason"=>"length"}],
#  "usage"=>{"prompt_tokens"=>4, "completion_tokens"=>5, "total_tokens"=>9}}

#get specific contexts
  #for encounter
  #for quest
  #for person
  #for place
  #for thing
  #for plottwist
  #loot, alterior ,motive, lore, secret, magic, ally, foe, hazard, blessing, curse

  #get specific formats    in hash for with specific labels
  #for encounter
  #for quest
  #for person
  #for place
  #for thing
  #for plottwist
  #loot, alterior ,motive, lore, secret, magic, ally, foe, hazard, blessing, curse
