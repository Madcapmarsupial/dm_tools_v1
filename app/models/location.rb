class Location < Field
  belongs_to :quest,
  optional: true

    store_accessor :completion, [:name, :summary, :description, :layout, :dwellers,
    :secrets, :lore, :history, :hazards, :narrative_connections]
  

     def self.get_type
       "location"
     end

    def self.blank_context(options)
      str = <<~EOT
      In an rpg scenario with a #{options["setting"]} as the setting, a #{options["objective"]} as the objective, and a #{options["villain"]} as the villain" 
      EOT
      str
    end

    def self.blank_prompt(options)
      str = <<~EOT
      #{self.blank_context(options)}
      create the #{get_type} in more detail.
      Your response should have #{param_list.length} parameters #{param_string}
      #{self.specifics}
      Your response should be in JSON format
      EOT
      str
    end


     def self.specifics
      str = <<~EOT
      The description parameter should have 4 parameters "sights", "sounds", "smells", and "atmosphere"
      The narrative_connections parameter should have 3 parameters "connection_to_players", "connection_to_villain", and "connection_objective"
      EOT
     end
      #The layout parameter should have rooms  room comp


end