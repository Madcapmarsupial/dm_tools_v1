class Villain < Field
  #attr_accessor :edge, :endgoal, :lair, :henchman, :backstory, :who
    belongs_to :quest

    store_accessor :completion, [:name, :description, :weaknesses, :motivation, 
    :special_abilities, :personality, :end_goal, :tragic_backstory, :redeeming_qualities, :lair, :henchman,
    :misguided_ideals, :planned_use_for_the_objective, :heinous_crime]
   
     def self.get_type
       "villain"
     end

     def self.blank_context(field)
      # setting and objective should be completions in this case. field a hash from params
      setting = Setting.find_by(quest_id: field[:quest_id])
      objective = Objective.find_by(quest_id: field[:quest_id])

      str = <<~EOT
      In an rpg scenario that has this data for the setting #{setting.completion}
      And this data for the objective #{objective.completion} 
      And a #{field["options"]["villian"]} as the villain" 
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

  
    #  def self.specifics
    #   str = <<~EOT
      
    #   EOT
    #  end




end