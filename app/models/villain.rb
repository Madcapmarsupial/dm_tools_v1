class Villain < Field
  #attr_accessor :edge, :endgoal, :lair, :henchman, :backstory, :who
    belongs_to :quest

    store_accessor :completion, [:name, :description, :weaknesses, :motivation, 
    :special_abilities, :personality, :end_goal, :tragic_backstory, :redeeming_qualities, :lair, :henchman,
    :noble_cause, :plan_for_the_objective, :heinous_crime]
  

     def self.get_type
       "villain"
     end
end