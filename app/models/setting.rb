class Setting < Field
  belongs_to :quest

    store_accessor :completion, [:setting_name, :summary, :description, :layout, :dwellers,
    :secrets, :lore, :history, :hazards, :narrative_connections]

    def self.blank_context(field)
      #completion is set to to the users input until it is overwritten by a generated response
      setting = Setting.find_by(quest_id: field[:quest_id])
      objective = Objective.find_by(quest_id: field[:quest_id])
      villain = Villain.find_by(quest_id: field[:quest_id])

      str = <<~EOT
      In an rpg scenario with a #{setting.s_context} as the setting, a #{objective.o_context} as the objective, and a #{villain.v_context} as the villain" 
      EOT
      str
    end

    #currently cant generate independent settings objective etc
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

    def s_context
      if completion != nil
        {
          "setting_name"=> self.setting_name,
          "summary"=> self.summary,
          "narrative_connections"=> self.narrative_connections,
          "lore"=> self.lore
          #"layout"=>self.layout,
        }
      else
        self.name
      end 
      #self.completion
    end

     def self.specifics
      str = <<~EOT
      The description parameter should have 4 parameters "sights", "sounds", "smells", and "atmosphere"
      The narrative_connections parameter should have 3 parameters "connection_to_players", "connection_to_villain", and "connection_to_objective"
      EOT
     end
      #The layout parameter should have rooms  room comp

    

end