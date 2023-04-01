class Setting < Field
  belongs_to :quest

    store_accessor :completion, [:setting_name, :summary, :description, :layout, :dwellers,
    :secrets, :lore, :history, :hazards, :narrative_connections]
  

     def self.get_type
       "location" 
     end

    def self.blank_context(field)
      user_values = Quest.find_by(id: field[:quest_id]).completion
      #completion is set to to the users input until it is overwritten by a generated response
      str = <<~EOT
      In an rpg scenario with a #{user_values["setting"]} as the setting, a #{user_values["objective"]} as the objective, and a #{user_values["villain"]} as the villain" 
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
      self.completion
    end

     def self.specifics
      str = <<~EOT
      The description parameter should have 4 parameters "sights", "sounds", "smells", and "atmosphere"
      The narrative_connections parameter should have 3 parameters "connection_to_players", "connection_to_villain", and "connection_to_objective"
      EOT
     end
      #The layout parameter should have rooms  room comp

    

end