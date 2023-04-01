class Quest < ApplicationRecord
  #validate :encounter_name_cannot_be_blank

  store_accessor :completion,  [:quest_name, :sequence_of_events, :summary, :outcomes, :key_emontional_moments, :overarching_themes, :plot_twist]
  #[:scenario_name, :description, :setting, :villain,
   # :timer, :objective, :success_consequence, :fail_consequence, :plot_twist, :encounter_list]
    #prefix?

  #encounters/events can have individual outcomes?  outcomes can be seperate generations? 
  #add an implementation of a quest.id_list for response version control.
  #stashed saved response for unsaved quests

  belongs_to :response,
   optional: true,
   class_name: "Response",
   foreign_key: :response_id,
   primary_key: :id

  has_many :encounters,
    class_name: 'Encounter',
    dependent: :destroy

  has_many :villains,
   class_name: 'Villain',
   dependent: :destroy

  has_many :settings,
    class_name: 'Setting',
    dependent: :destroy

  has_many :objectives,
    class_name: 'Objective',
    dependent: :destroy

  has_many :fields,
    class_name: 'Field',
    dependent: :destroy
#associations
  
  def q_context
    text = <<~EOT
    #{self.completion}
    EOT
  end

  def current_setting#(i)
    # to maintain a version history we would have to track an index for every child field.
      #or we pass a decrementer or an incrementor along params
      #instead of settings.last we do settings.all[index]  defualt being -1
      #this would only work until you start generating subresponses
      # <%= link_to '<', quest_url(@quest, :incrementor =>"-1", :current_id => @quest.current_setting(params).id) %>
      #we'd need a version history to store the working index
        #settings[-1 + i.to_i]
   settings.last || []
  end
  
  def self.prompt(quest_id)
    #options = {quest_name, linked_quest, imports}
    # def self.prompt(param_hash) #(system='dnd', encounters=4, theme='fantasy', context='') #context = QuestResponse.find_by()
   #  prompt = <<~EOT
   #  Create an rpg scenario with a #{param_hash[:villain]} as the villain, the setting is a #{param_hash[:setting]} and the objective is a #{param_hash[:objective]}
   #  Your response should be in JSON format with 10 parameters "scenario_name", "description", "villain", "setting", "objective", "timer" "success_consequence", "fail_consequence", "plot_twist", and "encounter_list"
   #  The "villain" parameter should hold 1 parameter "name"
   #  The "encounter_list" parameter should be an array of encounter names like [name_one, name_two]...
   #  Limit the scenario to 4 encounters.
   #  Don't use any symbols as keys in your response.
   #  Your response should contain no integers.
   #  EOT
    # end

    setting_context = Setting.find_by(quest_id: quest_id).s_context
    objective_context = Objective.find_by(quest_id: quest_id).o_context
    villain_context = Villain.find_by(quest_id: quest_id).v_context


    
   prompt = <<~EOT
    Create an rpg scenario with this data for the scenario setting #{setting_context} 
    This data for the scenario objective #{objective_context}
    And this data for the scenario villian #{villain_context}
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

  #  key_history
  #   k_list = Quest.all.map { |q| q.completion.keys }.uniq
    #   [
    #    ["timer", "setting", "villain", "objective", "plot_twist", "description", "scenario_name", "encounter_list", "fail_consequence", "success_consequence"],
    #    ["summary", "outcomes", "scenario_name", "plot_structure", "overarching_theme", "sequence_of_events", "key_emotional_moments"],
    #    ["summary", "outcomes", "scenario_name", "overarching_themes", "sequence_of_events", "key_emotional_moments"],
    #    ["summary", "outcomes", "plot_twist", "scenario_name", "overarching_themes", "sequence_of_events", "key_emotional_moments"],
    #    #["setting", "villain", "objective"],  should avoid these
    #    {"description" => "summary", "scenario_name" => "quest_name", "encounter_list" => "sequence_events" }
    #    ["summary", "outcomes", "plot_twist", "quest_name", "overarching_themes", "sequence_of_events", "key_emotional_moments"]
    #   ]
  # 

  def update_completion_keys(keys_hash)
    #need to build a hash of old_key -> new_key
    updated_completion = self.completion.transform_keys(keys_hash)
    self.update(completion: updated_completion)
  end

  def update_completion_sub_key(sub_key, keys_hash)
    if self.completion[sub_key].is_a?(Hash)
       updated_completion = self.completion[sub_key].transform_keys(keys_hash)
      self.update(completion: updated_completion)
    end
    p "invalid sub key -> #{completion[sub_key]}"
  end

  def update_completion_value(key)
  end




   def encounter_name_id_pairs
     e_hash = {}
    #   #be careful of creating multiple encounters
    #   #multiple genrations with the same name will overwrite each other

    self.encounters.each { |encounter| e_hash[encounter.encounter_name] = encounter.id }
    e_hash
  end

  # def encounter_name_cannot_be_blank
   #   if self.encounter_list.include?("")
   #     errors.add :encounter_list, :empty_encounter_name, message: ": your new encounter (name) was blank."
   #   end
  # end

end #class