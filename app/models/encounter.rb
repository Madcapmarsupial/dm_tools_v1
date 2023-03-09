class Encounter < Field
   store_accessor :completion, [:items, :rewards, :creatures, :time_limits, 
    :encounter_name, :location_description, :info, :fail_consequence, :threats, :area_layout]
    #update encounter name
    #deal with encounter versions
    #encounter prompt 
    #encounter layout
    #how do we group and display?
    #by threat/obstacles 

  
  def self.prompt(quest_id, name)
    #context  what needs to be context 
    #timer threat treat
    #sights sounds smells
    #keys
    #key count
    quest = Quest.find_by(id: quest_id)
    # <<~EOT
    # #{quest.context}
    # Return the encounter with the name #{name}. 
    # Your response should be in JSON format and each encounter should have 11 parameters "encounter_name", "description","location", "creatures", "items", "consequences", "obstacles", "magic", "secrets", "lore", and "active effects"
    # EOT


  
    <<~EOT
    #{quest.context}
    Return the encounter with the name #{name}.
    Your response should be in JSON format and each encounter should have 9 parameters "encounter_name", "location_description", "info", "area_layout", "creatures", "rewards", "threats", "time_limits", and "items"
    The "area_layout" parameter should have 2 parameters, "encounter-mechanics", "status-effects"
    The "info" parameter should have 3 parameters "secrets", and "lore", "consequences" 
    The "location_description" parameter should should have 4 parameters "surroundings", "sights", "sounds", and "smells"
    The "creatures" parameter should be a list of JSON hashes representing the creatures present in the encounter IE. [{name: "goblin", count: "3", attitude: "hostile"}, {name: "butler", count: "1", "neutral"}, {name: "princess", count: "1", attitude: "helpful"}]
    The parameter "time_limits" should be a list of "timers"
    A "timer" should be a JSON hash with 5 parameters "title", "description", "cause", "effect", and "turn duration"
    Add at least one timer to "time_limits"
    EOT
  end

  def desc_bundle
    timers = time_limits.map { |timer| timer["description"]}

    <<~EOT
    #{location_description["surroundings"]}
    #{location_description["sights"]}
    #{location_description["sounds"]}
    #{location_description["smells"]}
    #{timers.join(" ")}

    EOT
  end

  def creature_list
    #creatures.each do 
      #Creature.new(name goblin, count 3, attitude: hostile)
  end

  def mechanics_bundle
    str = time_limits.map do |timer|
      "#{timer["title"]} - in #{timer["turn_duration"]} rounds\n #{timer["effect"]} - #{timer["cause"]}"
    end

    <<~EOT
    #{str.join(" ")}
    #{area_layout}
    #{creatures}
    EOT
  end

  def reward_bundle
    <<~EOT
    #{items}
    #{info["lore"]}
    #{info["secrets"]}
    #{info["consequences"]}
    EOT
  end
end