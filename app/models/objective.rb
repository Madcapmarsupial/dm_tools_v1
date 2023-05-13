class Objective < Field
  belongs_to :quest

    store_accessor :completion, [:objective_name, :summary, :description, :current_owner, :current_location, 
      :effects_and_abilities, :use_cases, :interested_parties, :secrets, :conflicts_of_interest]




    def self.blank_context(field)
      #setting = Setting.find_by(quest_id: field[:quest_id])
      # setting should be a completion in this case

      setting = Setting.find_by(quest_id: field[:quest_id])
      objective = Objective.find_by(quest_id: field[:quest_id])
      villain = Villain.find_by(quest_id: field[:quest_id])



      str = <<~EOT
      In an rpg scenario that has this data for the setting #{setting.setting_context}
      And a #{objective.objective_context} as the objective
      And a #{villain.villain_context} as the villain" 
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

    def itemized
        {
          "objective_name" => self.objective_name,
          "appearance" => self.description["appearance"],
          "current_location" => self.current_location, 
          "current_owner"=> self.current_owner,
          "effects_and_abilities" => self.effects_and_abilities.map {|h| h["description"]}
        }
    end

    def objective_context
      if self.completion != {}
        {
          "summary" => self.summary,
          "objective_name" => self.objective_name,
          #"interested_parties" => self.interested_parties,
          "current_location" => self.current_location,
          "current_owner" => self.current_owner,
          "secrets" => self.secrets,
          #"conflicts_of_interest" => self.conflicts_of_interest,
        }
      else
        self.name
      end 

    end

     def self.specifics
      str = <<~EOT
      The parameter "description" should have 3 parameters "history", "lore", "appearance"
      The parameters "effects_and_abilities", "use_cases", "interested_parties", "secrets", and  "conflicts_of_interest" should all be lists
      Each entry in the lists above should have 2 parameters "name", and "description" 
      EOT
     end
      #The lay

      #  def hidden_keys
      #   [ "objective_name"]
      # end

    private
    def self.ai_values
      []
    end

end