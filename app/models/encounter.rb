class Encounter < Field
    #update encounter name
    #deal with encounter versions
  
  def self.prompt(quest_id, name)
    #context
    #keys
    #key count
    quest = Quest.find_by(id: quest_id)
    <<~EOT
    #{quest.context}
    Return the encounter with the name #{name}. your response should be in JSON format and each encounter should have 11 parameters "encounter_name", "description","location", "creatures", "items", "consequences", "obstacles", "magic", "secrets", "lore", and "active effects"
    EOT
  end
end