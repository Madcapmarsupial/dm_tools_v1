class Villain < Field
  #attr_accessor :edge, :endgoal, :lair, :henchman, :backstory, :who
    belongs_to :quest

    store_accessor :completion, [
      #info
        :villain_name, :description, :motivation, :appearance, 
      #roleplay
        :personality, :end_goal, :tragic_backstory, :redeeming_qualities,
        :misguided_ideals, :planned_use_for_the_objective, :the_story_of_the_most_recent_victim,
      #mechanics
        :special_abilities, :weaknesses, :lair, :henchman
    ]
   
  

     def self.blank_context(field)
      #setting and objective should be completions in this case. field a hash from params
      setting = Setting.find_by(quest_id: field[:quest_id])
      objective = Objective.find_by(quest_id: field[:quest_id])
      villain = Villain.find_by(quest_id: field[:quest_id])


      str = <<~EOT
      In an rpg scenario that has this data for the setting #{setting.setting_context}
      And this data for the objective #{objective.objective_context} 
      And a #{villain.villain_context} as the villain" 
      EOT
      str
    end

    def self.prompt(field)
      str = <<~EOT
      #{self.blank_context(field)}
      create the #{get_type} in more detail.
      Your response should have #{param_list.length} parameters #{param_string}
      Your response should be in JSON format
      EOT
      str
    end

    def villain_context
      if self.completion != {}
        {
        "villain_name" => self.villain_name,
        "planned_use_for_the_objective" => self.planned_use_for_the_objective,
        "end_goal" => self.end_goal,
        # "tragic_backstory" => self.tragic_backstory,
        # "the_story_of_the_most_recent_victim" => self.the_story_of_the_most_recent_victim,
        # "misguided_ideals" => self.misguided_ideals
        }
      else
        self.name
      end 
    end

  
    #  def self.specifics
    #   str = <<~EOT
      
    #   EOT
    #  end

    private
    def self.ai_values
      []
    end





end