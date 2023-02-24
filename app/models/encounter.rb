class Encounter < ApplicationRecord
  
  belongs_to :quest,
  foreign_key: :quest_id,
  primary_key: :id

  has_many :responses,
  class_name: 'EncounterResponse',
  dependent: :destroy


  def text
    responses.last.text_to_hash
  end








  def create_prompt
    #we need this to pass into the EncounterResponse object and the BOT
    #the context is the response prompt and text of the encounters parent
    #self.quest.response
    <<~EOT
    #{self.quest.context}
    Return the encounter with the name #{self.name}. your response should be in JSON format and each encounter should have 11 parameters "encounter_name", "description","location", "creatures", "items", "consequences", "obstacles", "magic", "secrets", "lore", and "active effects"
    EOT

  end

  

  #move to controller and make private?
  def create_completion_and_response #(prompt="this is a test", token_count=1)   #temperature #p_top???, #stop_limit
    #context gets passed in with encounter prompts

    prompt = self.create_prompt
    token_count = 2000

    myBot = OpenAI::Client.new
    response = myBot.completions(parameters: { model: "text-davinci-003", prompt: prompt, max_tokens: token_count})
    #??? to_json

    #prompt should equal defualt prompt plus parent context. which means we shouldnt have to pass args

    #we must make sure the AI Response is parseable
    EncounterResponse.create(full_response: response, prompt: prompt, encounter_id: self.id)
    p "encounter response generated {context: encounter model}"

    #slice(4..-1)

    #actually returns a HTTParty::Response
    #still need context
  end 
end