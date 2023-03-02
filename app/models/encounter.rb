class Encounter < ApplicationRecord
  
  belongs_to :quest,
  foreign_key: :quest_id,
  primary_key: :id,
  dependent: :destroy

  belongs_to :response,
  class_name: "Response",
  foreign_key: :response_id,
  primary_key: :id

  def create_prompt
    #context
    #keys
    #key count
    <<~EOT
    #{self.quest.context}
    Return the encounter with the name #{self.name}. your response should be in JSON format and each encounter should have 11 parameters "encounter_name", "description","location", "creatures", "items", "consequences", "obstacles", "magic", "secrets", "lore", and "active effects"
    EOT
  end
end