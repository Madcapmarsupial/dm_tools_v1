class Encounter < Field
   store_accessor :completion, [:rewards, :creatures, :active_effects,
    :encounter_name, :location_description, :area_layout]

    #fields should be signle 
    #or be lists have generic name and description keys

    #update encounter name
    #deal with encounter versions
    #encounter prompt 
    #encounter layout
    #how do we group and display?
    #by threat/obstacles 

    #npcs
    has_many :creature_models,
    class_name: 'Creature',
    primary_key: :id,
    foreign_key: :field_id

     has_many :reward_models,
    class_name: 'Reward',
    primary_key: :id,
    foreign_key: :field_id

     has_many :mechanic_models,
    class_name: 'SpecialMechanic',
    primary_key: :id,
    foreign_key: :field_id

     has_many :effect_models,
    class_name: 'ActiveEffect',
    primary_key: :id,
    foreign_key: :field_id


    belongs_to :quest


    #active_effects
    #rewards
    #creatures
    #special_mechanics

    def component_list_types
      ["creature", "reward", "special_mechanic", "active_effect"]
    end

    def list_of(type_str)
         model_lists = {
        "creature" => self.creature_models,
        "reward" => self.reward_models,
        "special_mechanic" => self.mechanic_models,
        "active_effect" => self.effect_models
       }
       
       model_lists[type_str.downcase]
    end


    def model_names(type_str)
      #must be a list
      #list items must have a name attribute
      list_of(type_str).map(&:name)
    end



    #encounter.comp_list_types -> 
       #['creature', 'reward', 'active_effect'] 
    #list_of(type)
      #model collection
    #name_list
      #include?

  
    def comp_lists
      component_list = []
      completion.each do |list_type, list|
       list.is_a?(Array) 
       component_list << list_type.singularize
       #['creature', 'reward', 'active_effect'] 
      end
    end

    def comp_singles
        completion.each do |list_type, list|
       list.is_a?(Array) 
       comp_type = list_type.singularize
        end
    end



#LOCATION
#   "location_description"=>
#     {"sights"=>"The air is heavy with dust and smoke and you can see a throne atop a high dais in the center of the room.",
#      "smells"=>"Strong, sweet incense permeates the room.",
#      "sounds"=>"Echoing chants and incantations fill the air.",
#      "surroundings"=>"A high and sour cave, encrusted with ancient minerals and lined with large, burning candles."}},



  
  def self.prompt(quest_id, name)
    #context  what needs to be context 
    #timer threat treat
    #sights sounds smells
    #keys
    #key count
    quest = Quest.find_by(id: quest_id)
    # <<~EOT
    # #{quest.context}
    # Return the encounter with the name #{name}. 
    # Your response should be in JSON format and each encounter should have 11 parameters "encounter_name", "description","location", "creatures", "items", "consequences", "obstacles", "magic", "secrets", "lore", and "active effects"
    # EOT

    # title cause penelty turn duration 
  
    # <<~EOT
    # #{quest.context}
    # Return the encounter with the name #{name}.
    # Your response should be in JSON format and each encounter should have 10 parameters "encounter_name", "location_description", "secrets", "lore" "area_layout", "creatures", "rewards", "threats", "time_limits", and "items"
    # The "area_layout" parameter should have 2 parameters, "encounter-mechanics", "status_effects"
    # The "location_description" parameter should should have 4 parameters "surroundings", "sights", "sounds", and "smells"
    # The "creatures" parameter should be a list of JSON hashes representing the creatures present in the encounter IE. [{name: "goblin", count: "3", attitude: "hostile"}, {name: "butler", count: "1", "neutral"}, {name: "princess", count: "1", attitude: "helpful"}]
    # The parameter "time_limits" should be a list of "timers"
    # A "timer" should be a JSON hash with 3 parameters "title", "description", and "penalty"
    # Add at least one timer to "time_limits"
    # EOT


    <<~EOT
    #{quest.context}
    Return the encounter with the name #{name}.
    Your response should be in JSON format and each encounter should have 7 parameters "encounter_name", "location_description", "area_layout", "creatures", "rewards" "active_effects", and "special_mechanics"
    The "creatures", "rewards", "active_effects" and "special_mechanics" parameters should all be a lists
    Each "creature", "reward", "active_effect", and  "special_mechanic" should have 2 parameters "name", and "description"
    The "location_description" parameter should should have 4 parameters "surroundings", "sights", "sounds", and "smells"
    make the encounter time sensitive somehow using the "active_effects" and or "special_mechanics" parameters
    EOT
  end


  #cascading responses.
    #broadstrokes encounter response
    #broad strokes creature response
    #etc
    #bundle 
    #then deliver



    def context_for_component
      quest_context = self.quest.completion.to_json  
      encounter_contex = self.completion.to_json
      component_context = <<~EOT
      #{quest_context}
      #{encounter_contex}
      EOT
       #self.quest.encounter_contex 
       #its just the completion for now
    end


#CREATURE
#    "creatures"=>[{"name"=>"High Priest", "count"=>"1", "attitude"=>"Neutral"}],
#creature type

#    "area_layout"=> {
 #    "status_effects"=>"Intimidation and fear can be used to speed up your mission, but greed and vanity will slow things down.",
#      "encounter_mechanics"=>  "The High Priest will offer little resistance and requires no battle, but will still present a challenge. You must gather the relic from his clutches."},

 



end