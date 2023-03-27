class Quest < ApplicationRecord
  #validate :encounter_name_cannot_be_blank

  store_accessor :completion,  [:scenario_name, :sequence_of_events, :summary, :outcomes, :key_emontional_moments, :overarching_themes, :plot_twist]
  #[:scenario_name, :description, :setting, :villain,
   # :timer, :objective, :success_consequence, :fail_consequence, :plot_twist, :encounter_list]
    #prefix?


   #encounters/events can have individual outcomes?  outcomes can be seperate generations? 

  #add an implemntation of a quest.id_list for response version control.
  #stashed saved response for unsaved quests

  belongs_to :response,
  class_name: "Response",
  foreign_key: :response_id,
  primary_key: :id

  has_many :encounters,
  class_name: 'Encounter',
  dependent: :destroy

  has_many :villains,
  class_name: 'Villain',
  dependent: :destroy

    has_many :locations,
  class_name: 'Location',
  dependent: :destroy

    has_many :objectives,
  class_name: 'Objective',
  dependent: :destroy

  has_many :fields,
  class_name: 'Field',
  dependent: :destroy

  def context
    text = <<~EOT
    #{self.completion}
    EOT
  end


  # def self.prompt(param_hash) #(system='dnd', encounters=4, theme='fantasy', context='') #context = QuestResponse.find_by()
  #   prompt = <<~EOT
  #   Create an rpg scenario with a #{param_hash[:villain]} as the villain, the setting is a #{param_hash[:setting]} and the objective is a #{param_hash[:objective]}
  #   Your response should be in JSON format with 10 parameters "scenario_name", "description", "villain", "setting", "objective", "timer" "success_consequence", "fail_consequence", "plot_twist", and "encounter_list"
  #   The "villain" parameter should hold 1 parameter "name"
  #   The "encounter_list" parameter should be an array of encounter names like [name_one, name_two]...
  #   Limit the scenario to 4 encounters.
  #   Don't use any symbols as keys in your response.
  #   Your response should contain no integers.
  #   EOT
  # end

  def self.prompt(options)
   prompt = <<~EOT
    Create an rpg scenario with this data for the scenario setting #{options["setting_completion"]} 
    This data for the scenario objective #{options["objective_completion"]}
    And this data for the scenario villian #{options["villain_completion"]}
    Your response should be in JSON format with #{param_list.length} parameters #{param_string}
    Limit the scenario to 5 "events"
    #{specifics}
    EOT
  end

  def self.param_list
    stored_attributes[:completion]
  end

  def self.specifics
    str = <<~EOT
      The "sequence_of_events" parameter should be a list
      Each "event" should have 4 parameters "order_number", "title", "description", "next_steps"
      The "plot_twist" parameter should have "5" parameters "the liar",  "the lie", "the truth", "the consequences", and  "the clues"
    EOT
  end 

  def self.param_string
    param_list.slice(0...-1).join(", ") + " and #{param_list.last}"
  end


  def encounter_list
    #list = []
    #self.sequence_of_events.each {|event| list << event['title']}
    sequence_of_events
  end

   def get_encounter(name)
     #{'encounter_name' => name}
     index = self.encounter_list.find_index(name)
     self.encounter_list[index]
   end

  # def add_encounter(event) #{name, order, desc}
  #   titleize, capitalize
  #   self.sequence_of_events << event # name.titleize
  # sort by order_number
  #   self
  # end



  # def edit_encounter_name(new_name, old_name) #deal with capitalization
  #     #returns a string to be used in creating a new QuestResponse
  #   index = self.response.encounters_array.find_index(old_name) #{'encounter_name' => old_name}
  #       #[{"encounter_name"=>"The Wailing Wood"}, {"encounter_name"=>"The Harvest of Souls"}, {"encounter_name"=>"The Arboreal Abomination"}, {"encounter_name"=>"The Relic of Rot"}]
  #   text_hash = self.response.text_to_hash
  #   text_hash["encounter_list"][index] = new_name   #{'encounter_name' => new_name} be carful of this syntax
  #     #text_hash now has the new name in the encounter_list list
  #   self.staged_response = text_hash.to_json
  #   #may need to us update here
  #   #adds to staged
  # end

   def encounter_name_id_pairs
     e_hash = {}
  #   #be careful of creating multiple encounters
  #   #multiple genrations with the same name will overwrite each other

    self.encounters.each { |encounter| e_hash[encounter.name] = encounter.id }
    e_hash
  end


  # def encounter_name_cannot_be_blank
  #   if self.encounter_list.include?("")
  #     errors.add :encounter_list, :empty_encounter_name, message: ": your new encounter (name) was blank."
  #   end
  # end
end #class