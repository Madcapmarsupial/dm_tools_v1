class EncounterResponse < ApplicationRecord
  belongs_to :encounter,
  primary_key: :id,
  foreign_key: :encounter_id

  #text
  #text_to_hash
  #usage
  #choices
  #prompt

  #make a response module? 
   
  def return_text
    #JSON.parse(full_response)   # symbolize_names: true

    text = JSON.parse(full_response)["choices"][0]["text"]
    #json = JSON.generate(ruby)

    #hash['choices'][0]['text']
    # "\nA: {\"Encounter_name\"=>\"Wolf Attack\", \"Description\"=>\"The players have stumbled across a pack of wolves, and must find a way to get past them before the creatures attack.\", \"Location\"=>\"A dense forest\", \"Creatures\"=>\"A pack of hungry wolves\", \"Items\"=>\"None\", \"Consequences\"=>\"If the players do not get past the wolves, they will be attacked and potentially killed.\", \"Obstacles\"=>\"The wolves are blocking the path and attacking anyone who comes too close.\", \"Magic\"=>\"None\", \"Secrets\"=>\"None\", \"Lore\"=>\"The wolves were once peaceful creatures, but were driven mad by a mysterious magical force.\", \"Active Effects\"=>\"The wolves are enraged and will attack anyone that they perceive as a threat.\"}"
  end

  def text_to_hash  
    JSON.parse(return_text)
  end

   def get(element)
     self.text_to_hash[element]
   end


end
