class Quest < ApplicationRecord
  #validate :encounter_name_cannot_be_blank
  include Generatable

  store_accessor :completion,  [
    :quest_name, :summary,
     :villain_name, :setting_name, :objective_name,
     :sequence_of_events, :outcome_list, :ongoing_threat]

     #other_ideas_and_suggestions
     
  #[:scenario_name, :description, :setting, :villain,
    #add spectacle here??
    # :timer, :objective, :success_consequence, :fail_consequence, :plot_twist, :encounter_list]
    #prefix?

#asccotiations  
  belongs_to :response,
   optional: true,
   class_name: "Response",
   foreign_key: :response_id,
   primary_key: :id

  has_many :scenes,
    class_name: 'Scene',
    dependent: :destroy
  
  has_many :frames, through: :scenes

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

  has_many :quest_details,
    foreign_key: :quest_id,
    dependent: :destroy

  has_many :details,
    through: :quest_details,
    dependent: :destroy
#asso-end

  
#after the intial creation in the case of generation (Quest needs to keeps its sequence of events value up to date )
#via its Scenes children
  


  def prereqs_met?
    (!villains.empty? && !objectives.empty? && !settings.empty?)
  end
  
  def scene_list
    scenes
  end

  def encounter_list
    scenes
  end

  def non_scene_fields
    fields.where.not(type: "Scene")
  end

  def current_setting
    settings.last || Setting.new 
  end 

  def current_objective
    objectives.last || Objective.new
  end 
  
  def current_villain
    villains.last || Villain.new
  end 

  


#PROMPT METHODS
  def q_context
    text = <<~EOT
    In a table-top rpg with the following summary "#{self.summary}"
    And this scene-list #{self.sequence_of_events}
    EOT
    #{self.completion}
  end

  def self.get_type
    "quest"
  end

  def child_type
    "field"
  end

  # contexts are currentlt set by finding the spcific field type by quest_id
  def s_o_v_context
    #add user_values to else of field contexts
    {
      "setting" => settings.last.setting_context,
      "objective" => objectives.last.objective_context,
      "villain" => villains.last.villain_context
    }
  end


  def self.prompt(quest_params)
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

    s_context = Setting.find_by(quest_id: quest_params[:id]).setting_context
    o_context = Objective.find_by(quest_id: quest_params[:id]).objective_context
    v_context = Villain.find_by(quest_id: quest_params[:id]).villain_context




   # gonna need a import_context method 
   prompt = <<~EOT
    Create an rpg scenario with this data for the scenario setting #{s_context} 
    This data for the scenario objective #{o_context}
    And this data for the scenario villian #{v_context}
    Your response should be in JSON format with #{param_list.length} parameters #{param_string}
    #{specifics}
    EOT
  end

  def self.param_list
    stored_attributes[:completion]
  end

  

  def self.specifics
    str = <<~EOT
      The "sequence_of_events" parameter should be a list
      Limit the scenario to 5 "events"
      Each "event" should have 4 parameters "order_number", "title", "description", and "narrative_connection_to_next_event"
      The parameter "ongoing_threat" should have 3 parameters "name", "effect_description", and "frequency"
      The parameter "outcome_list" should hold 3 types of outcome, "success", "failure", and "partial_success"
      Each "outcome" should have 2 parameters "title", and "description"
    EOT
  end 
  #     "narrative_connection_to_next_outcome"=>nil}


  # "outcomes"=>
  #   [{"title"=>"Success",
  #     "description"=>
  #      "The players successfully neutralize the curse on the Ancient Tome of Arcturia and defeat Malakar, preventing him from gaining ultimate power over life and death.",

  #on_completion,

  def self.param_string
    param_list.slice(0...-1).join(", ") + " and #{param_list.last}"
  end
#

  def get_encounter(name)
    #{'encounter_name' => name}
    index = self.encounter_list.find_index(name)
    self.encounter_list[index]
  end

    #def current_setting#(i)
    # to maintain a version history we would have to track an index for every child field.
      #or we pass a decrementer or an incrementor along params
      #instead of settings.last we do settings.all[index]  defualt being -1
      #this would only work until you start generating subresponses
      # <%= link_to '<', quest_url(@quest, :incrementor =>"-1", :current_id => @quest.current_setting(params).id) %>
      #we'd need a version history to store the working index
        #settings[-1 + i.to_i]
   #settings.last || []
  #end
  


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

  def hidden_keys
    ["sequence_of_events"]
  end
  

  private



end #class