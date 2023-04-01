class Objective < Field
  belongs_to :quest

    store_accessor :completion, [:objective_name, :summary, :description, :lore, :current_owner, :current_location, 
      :effects_and_abilites, :use_cases, :interested_parties, :secrets, :conflicts_of_interest]
  

     def self.get_type
       "objective"
     end

    def self.blank_context(field)
      setting = Setting.find_by(quest_id: field[:quest_id])
      # setting should be a completion in this case
      str = <<~EOT
      In an rpg scenario that has this data for the setting #{setting.s_context}
      And a #{field["options"]["objective"]} as the objective
      And a #{field["options"]["villain"]} as the villain" 
      EOT
      str
    end

    def self.prompt(field)
      str = <<~EOT
      #{self.blank_context(field)}
      create the #{get_type} in more detail.
      Your response should have #{param_list.length} parameters #{param_string}
      #{self.specifics}
      Your response should be in JSON format
      EOT
      str
    end


    def o_context
      {
        "objective_name" => self.objective_name,
        "interested_parties" => self.interested_parties,
        "current_location" => self.current_location,
        "current_owner" => self.current_owner,
        "secrets" => self.secrets,
        "conflicts_of_interest" => self.conflicts_of_interest,
        "summary" => self.summary
      }
    end

     def self.specifics
      str = <<~EOT
      The parameters "effects_and_abilites", "use_cases", "interested_parties", "secrets", and  "conflicts_of_interest" should all be lists
      Each entry in the lists above should have 2 parameters "name", and "description" 
      EOT
     end
      #The lay
end