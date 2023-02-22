class Quest < ApplicationRecord
  #attr_accessor :scenario_name, :description, :Encounter_list, :villain, :objective, :setting, :timer, :plottwist
  #deleteing a quest will delete all fields and traits associatiated with it
  has_many :fields,
  dependent: :destroy

  has_many :children,
  through: :fields,
  source: :children,
  dependent: :destroy

  has_many :responses,
  class_name: 'QuestResponse',
  dependent: :destroy

  has_many :encounters,
  class_name: 'Encounters'


   #add a staged_respose column to the quest to (add edit remove) 
    # the staged_response can hold the response text and then be edited to refelct un-generated user changes. 
    #   this will keep the response og and 'pure'
    #new encounter = prompt = (quest prompt + quest staged_response + encounter_lvl_prompt)

  def context
   #we need to manange the Q: A:
    answer = JSON.parse(self.staged_response)
    #answer = responses.last.text_to_hash
    string = <<~EOT
    Q: #{responses.last.prompt}
    A: #{answer}
    EOT
  end

  def response
    responses.last
  end

  def quest_prompt(param_hash) #(system='dnd', encounters=4, theme='fantasy', context='') #context = QuestResponse.find_by()
    prompt = <<~EOT 
    Create a dnd scenario with a #{param_hash[:villain]} as the villain, the setting is a #{param_hash[:setting]} and the objective is a #{param_hash[:objective]} and limit the scenario to 4 encounters. 
    Your response should be in JSON format with 8 paramaters "scenario_name", "description", "villain", "setting", "objective", "timer", "plot_twist", and "encounter_list".
    The "villain" parameter should hold 1 parameter: "name". 
    The "encounter_list" parameter should be an array encounter names like [name_one, name_two]...

    EOT
  end

  def edit_encounter_name(new_name, old_name) #deal with capitalization
      #returns a string to be use in creating a new QuestResponse
    index = self.response.encounters_array.find_index({"encounter_name" => old_name}) #{'encounter_name' => old_name}
        #[{"encounter_name"=>"The Wailing Wood"}, {"encounter_name"=>"The Harvest of Souls"}, {"encounter_name"=>"The Arboreal Abomination"}, {"encounter_name"=>"The Relic of Rot"}]
    text_hash = self.response.text_to_hash
    text_hash["encounter_list"][index] = new_name   #{'encounter_name' => new_name} be carful of this syntax
      #text_hash now has the new name in the encounter_list list
    self.staged_response = text_hash.to_json  
    #may need to us update here
    #adds to staged
  end




  #fields
  def last_created_field
    list = self.fields
    result = list.order(created_at: :desc).first
    if result == nil
      result = Field.new
    end
    result
  end

  def set_pointer
    #returns the type field that should be created next
    queue[last_created_field.type] || 'Setting'
  end

  def queue
    { 'Setting' => 'Villain', 'Villain' => 'Objective', 
      'Objective' => 'PlotTwist', 'PlotTwist'=> 'Custom', 'Custom' => 'Custom' }
       #=> 'PlotTwist','PlotTwist' 

      
  end

  # def villain
  #   @villain ||= Villain.create(label: 'person', value: 'villain', quest_id: self.id)
  # end 

  def villain_input
    #gets all villains from quest
    fields.find_by(type: 'Villain')
  end

  def setting_input
    #gets all villains from quest
    fields.find_by(type: 'Setting')
  end

  def objective_input
    #gets all villains from quest
    fields.find_by(type: 'Objective')
  end
end
