class Villain < Field
  #attr_accessor :edge, :endgoal, :lair, :henchman, :backstory, :who
    belongs_to :quest,
    optional: true

    store_accessor :completion, [:name, :description, :weaknesses, :motivation, 
    :special_abilities, :personality, :end_goal, :tragic_backstory, :redeeming_qualities, :lair, :henchman,
    :misguided_ideals, :planned_use_for_the_objective, :heinous_crime]
  
     def self.get_type
       "villain"
     end

     def self.blank_context(options)
      str = <<~EOT
      In an rpg scenario that has this data for the setting #{options["setting_completion"]}
      And this data for the objective #{options["objective_completion"]} 
      And a #{options["villain"]} as the villain" 
      EOT
      str
    end

    def self.blank_prompt(options)
      str = <<~EOT
      #{self.blank_context(options)}
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