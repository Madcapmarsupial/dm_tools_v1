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


  def self.quest_prompt(param_hash) #(system='dnd', encounters=4, theme='fantasy', context='') #context = QuestResponse.find_by()
    #quest_keys
    #quest_keys.length
    prompt = <<~EOT
    Create an rpg scenario with a #{param_hash[:villain]} as the villain, the setting is a #{param_hash[:setting]} and the objective is a #{param_hash[:objective]}
    Your response should be in JSON format with 10 parameters "scenario_name", "description", "villain", "setting", "objective", "timer" "success_consequence", "fail_consequence", "plot_twist", and "encounter_list"
    The "villain" parameter should hold 1 parameter "name" 
    The "encounter_list" parameter should be an array of encounter names like [name_one, name_two]...
    Limit the scenario to 4 encounters. 
    Don't use symbols as keys in your response
    EOT
  end


  def context
    #should return the context needed to create a new Response
    #that reslates to this quest 

    quest = self.completion
    #"With this rpg quest in JSON format as contex: #{self.completion}\n ACTION "
  end

  def get_encounter(name)
    #{'encounter_name' => name}
    index = self.encounter_list.find_index(name)
    self.encounter_list[index]
  end

  def edit_encounter_name(new_name, old_name) #deal with capitalization
      #returns a string to be use in creating a new QuestResponse
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
    self.encounters.each { |encounter| e_hash[encounter.name] = encounter.id }
    e_hash
  end 





  
  # def set_pointer
  #   #returns the type field that should be created next
  #   queue[last_created_field.type] || 'Setting'
  # end

  # def queue
  #   { 'Setting' => 'Villain', 'Villain' => 'Objective', 
  #     'Objective' => 'PlotTwist', 'PlotTwist'=> 'Custom', 'Custom' => 'Custom' }
  #      #=> 'PlotTwist','PlotTwist' 

      
  # end

  # def villain
  #   @villain ||= Villain.create(label: 'person', value: 'villain', quest_id: self.id)
  # end 

  # def villain_input
  #   #gets all villains from quest
  #   fields.find_by(type: 'Villain')
  # end

  # def setting_input
  #   #gets all villains from quest
  #   fields.find_by(type: 'Setting')
  # end

  # def objective_input
  #   #gets all villains from quest
  #   fields.find_by(type: 'Objective')
  # end
end



