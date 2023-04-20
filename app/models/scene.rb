class Scene < Field
  store_accessor :completion, [  
    #description
      :scene_name, :summary, :area_description, :area_layout, :the_impressive_spectacle, 
    #

    #key fields
       :scene_goal, :sense_of_danger, :scene_obstacle, :next_steps_for_players,
       #effect_description  #frequency #potential_solutions    #quest_items
        #"the_primary_threat", "the_consequences_of_failure", "the_victims", and "added_complications_of_failure"
    #

    #tables and mechanics
      :reward_list, :creature_list, :active_effect_list, :special_mechanic_list
    #       
    ]

   #scenes can have individual outcomes?  outcomes can be seperate generations? 
    #add an implementation of a quest.id_list for response version control.
    #stashed saved response for unsaved quests

  #assoctiations
    belongs_to :quest

    belongs_to :response,
    optional: true

    has_many :frames,
      class_name: "Frame",
      foreign_key: :field_id,
      primary_key: :id,
      dependent: :destroy

    #field subclasses
    has_many :creatures,
     class_name: 'Creature',
     primary_key: :id,
     foreign_key: :field_id,
     dependent: :destroy
 
    has_many :reward_models,
      class_name: 'Reward',
      primary_key: :id,
      foreign_key: :field_id,
     dependent: :destroy


    has_many :mechanic_models,
      class_name: 'SpecialMechanic',
      primary_key: :id,
      foreign_key: :field_id,
     dependent: :destroy


    has_many :effect_models,
      class_name: 'ActiveEffect',
      primary_key: :id,
      foreign_key: :field_id,
      dependent: :destroy


    has_many :components,
      primary_key: :id,
      foreign_key: :field_id,
     dependent: :destroy

  #assoctiations-end

  
    def order_number
      (quest.scenes.count).to_s
    end

   

    def add_component(parameters)
      #make sure name is present is valid 
      new_component = {"name" => parameters[:name].titleize, "description" => parameters[:description].capitalize}

      self.component_lists[parameters[:type]] << new_component
      self.completion
    end

    def component_list_types
      #freeze
      ["creature", "reward", "special_mechanic", "active_effect"]
    end

    def model_names(type_str)
      #must be a list
      #list items must have a name attribute
      list_of(type_str).map(&:name)
    end

     def list_of(type_str)
      #refactor and freeze
         model_lists = {
        "creature" => self.creature_models,
        "reward" => self.reward_models,
        "special_mechanic" => self.mechanic_models,
        "active_effect" => self.effect_models
       }
       
       model_lists[type_str.downcase]
    end

    def component_lists
      #refactor and freeze
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
    Generate the scene with the name "#{field["name"]}" and the description "#{field["description"]}".
    Your response should be in JSON format and each scene should have #{param_list.length} parameters #{param_string}
    Each "creature", "reward", "active_effect", and  "special_mechanic" within their respictive list should have 2 parameters "name", and "description"
    The "area_description" parameter should should have 4 parameters "surroundings", "sights", "sounds", and "smells"
    The "sense_of_danger" parameter should have 4 parameters "the_primary_threat", "the_consequences_of_failure", "the_victims", and "added_complications_of_failure"
    make the scene time sensitive somehow using the "active_effects" and or "special_mechanics" and "sense_of_danger" parameters
    EOT
  end

  # The parameter "scene_obstacle" should have 3 paramaters "name", "description" and  "possible_solution_list"

    def context_for_component
      quest_context = self.quest.completion
      scene_contex = self.completion
      component_context = <<~EOT
      #{quest_context}
      #{scene_contex}
      EOT
       #self.quest.scene_contex 
       #its just the completion for now
    end

    # def create_user_response(user_id, field_hash)
    #   user_completion =  {
    #     "usage"=>{"total_tokens"=>0, "prompt_tokens"=>0, "completion_tokens"=>0},
    #     "choices"=>
    #     [
    #       {
    #         "index"=>0,
    #         "message"=> {
    #         "role"=>"assistant",
    #         # sanitize user input
    #         "content"=> field_hash.to_json
    #       },
        
    #     "finish_reason"=>"stop"}
    #     ],
    #     "created"=>1680407028
    #   }      
    #   values = {user_id: user_id, completion: user_completion, prompt: "blank_#{self.type.downcase}"}
    # end

    def hidden_keys
      ["creature_list", "reward_list",  "active_effect_list", "special_mechanic_list"]
     # ["area_layout", "reward_list", "creature_list", "active_effect_list", "special_mechanic_list"].freeze
      #[:scene_name, :summary, :area_description, :area_layout, 
      #:the_impressive_spectacle, :next_steps_for_players, :scene_goal, 
      #:sense_of_danger, :scene_obstacle, :reward_list, :creature_list, 
      #:active_effect_list, :special_mechanic_list]
    end

  
private

    #the user will not interact with these fields
  
  
end#class


