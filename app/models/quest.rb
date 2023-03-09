class Quest < ApplicationRecord
  store_accessor :completion, [:scenario_name, :description, :setting, :villain, 
    :timer, :objective, :success_consequence, :fail_consequence, :plot_twist, :encounter_list]
    #prefix?
    
  #add an implemntation of a quest.id_list for response version control.
  #stashed saved response for unsaved quests
    
  belongs_to :response,
  class_name: "Response",
  foreign_key: :response_id,
  primary_key: :id

  has_many :encounters,
  class_name: 'Encounter',
  dependent: :destroy

  def context
    text = <<~EOT
    #{self.completion}
    EOT
  end


  def self.prompt(param_hash) #(system='dnd', encounters=4, theme='fantasy', context='') #context = QuestResponse.find_by()
    prompt = <<~EOT
    Create an rpg scenario with a #{param_hash[:villain]} as the villain, the setting is a #{param_hash[:setting]} and the objective is a #{param_hash[:objective]}
    Your response should be in JSON format with 10 parameters "scenario_name", "description", "villain", "setting", "objective", "timer" "success_consequence", "fail_consequence", "plot_twist", and "encounter_list"
    The "villain" parameter should hold 1 parameter "name" 
    The "encounter_list" parameter should be an array of encounter names like [name_one, name_two]...
    Limit the scenario to 4 encounters. 
    Don't use any symbols as keys in your response.
    Your response should contain no integers.
    EOT
  end

  def get_encounter(name)
    #{'encounter_name' => name}
    index = self.encounter_list.find_index(name)
    self.encounter_list[index]
  end

  def edit_encounter_name(new_name, old_name) #deal with capitalization
      #returns a string to be used in creating a new QuestResponse
    index = self.response.encounters_array.find_index(old_name) #{'encounter_name' => old_name}
        #[{"encounter_name"=>"The Wailing Wood"}, {"encounter_name"=>"The Harvest of Souls"}, {"encounter_name"=>"The Arboreal Abomination"}, {"encounter_name"=>"The Relic of Rot"}]
    text_hash = self.response.text_to_hash
    text_hash["encounter_list"][index] = new_name   #{'encounter_name' => new_name} be carful of this syntax
      #text_hash now has the new name in the encounter_list list
    self.staged_response = text_hash.to_json  
    #may need to us update here
    #adds to staged
  end

  def encounter_name_id_pairs
    e_hash = {}
    #be careful of creating multiple encounters
    #multiple genrations with the same name will overwrite each other
    
    self.encounters.each { |encounter| e_hash[encounter.name] = encounter.id }
    e_hash
  end 
end