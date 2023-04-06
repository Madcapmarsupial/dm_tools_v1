class Encounter < Field
   store_accessor :completion, [:reward_list, :creature_list, :active_effect_list, :special_mechanic_list, :the_impressive_spectacle,
    :encounter_name, :sense_of_danger, :area_description, :area_layout, :summary, :encounter_goal, :main_encounter_obstacle, :next_steps_for_players]
    #sense_of_danger, :primary_encounter_threat, primary_threat


    #fields should be single 
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

    def add_component(parameters)
      #make sure name is present is valid 
      new_component = {"name" => parameters[:name].titleize, "description" => parameters[:description].capitalize}

      self.component_lists[parameters[:type]] << new_component
      self.completion
    end

    def component_list_types
      ["creature", "reward", "special_mechanic", "active_effect"]
    end

    def model_names(type_str)
      #must be a list
      #list items must have a name attribute
      list_of(type_str).map(&:name)
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

    def component_lists
     component_lists = {
      "creature_list" => self.creature_list,
      "reward_list" => self.reward_list,
      "special_mechanic_list" => self.special_mechanic_list,
      "active_effect_list" => self.active_effect_list
    }
  end

  def get_component_by_name(type, name)
    list_of(type).find_by(name: name)
  end 


  def self.prompt(field)
    #field should be a hash from the params hash

    #context  what needs to be context 
    #timer threat treat
    #sights sounds smells
    #keys
    #key count
    quest = Quest.find_by(id: field["quest_id"])
    <<~EOT
    #{quest.q_context}
    Generate the encounter with the name #{field["name"]} and the description #{field["description"]}.
    Your response should be in JSON format and each encounter should have #{param_list.length} parameters #{param_string}
    Each "creature", "reward", "active_effect", and  "special_mechanic"within their respictive list should have 2 parameters "name", and "description"
    The "area_description" parameter should should have 4 parameters "surroundings", "sights", "sounds", and "smells"
    The "sense_of_danger" parameter should have 4 parameters "the_primary_threat", "the_consequences_of_failure", "the_victims", and "added_complications_of_failure"
    make the encounter time sensitive somehow using the "active_effects" and or "special_mechanics" and "sense_of_danger" parameters
    EOT
  end


    def context_for_component
      quest_context = self.quest.completion
      encounter_contex = self.completion
      component_context = <<~EOT
      #{quest_context}
      #{encounter_contex}
      EOT
       #self.quest.encounter_contex 
       #its just the completion for now
    end



    def create_user_response(user_id, field_hash)
      user_completion =  {
        "usage"=>{"total_tokens"=>0, "prompt_tokens"=>0, "completion_tokens"=>0},
        "choices"=>
        [
          {
            "index"=>0,
            "message"=> {
            "role"=>"assistant",
            # sanitize user input
            "content"=> field_hash.to_json
          },
        
        "finish_reason"=>"stop"}
        ],
        "created"=>1680407028
      }      
      values = {user_id: user_id, completion: user_completion, prompt: "blank_#{self.type.downcase}"}
    end

private
  
end#class


