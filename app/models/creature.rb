class Creature < Component
  belongs_to :scene,
  class_name: 'Scene',
  foreign_key: :field_id,
  primary_key: :id,
  dependent: :destroy
  #has mnay details

  store_accessor :completion, [:creature_name, :equipment, :description, :weaknesses, :bonuses,
    :special_abilities, :key_chracteristic, :personality, :motivation, :alignment, :tactics]


    #put these under detail?
    #backstory
    #ties_to_the_plot
    #conflicts_of_interest
    #lore
    #secrets

  

  # def self.prompt(params)
  #   scene = Scene.find_by(id: params[:field_id])
  #   parents_context = scene.context_for_component
  #   #scene.creature_context    # component_context
  #   #
  #   #build context
  #   if params[:alignment] != ""
  #     alignment_string = <<~EOT
  #     Make this creature #{params[:alignment]} to the player characters using the "alignment" parameter
  #     EOT
  #   else
  #     alignment_string = ""
  #   end

  #   <<~EOT
  #   In the context of the below rpg scenario and the specified scene
  #   #{parents_context}
  #   The "creature" named #{params[:name]} 
  #   Recreate this creature in more detail 
  #   The creature should have 9 parameters "name", "description", "weaknesses", "special_abilities", "quantity", "equipment", "bonuses", "key_chracteristic", "personality", "tactics", "alignment" and "motivation"
  #   #{alignment_string} 
  #   The "alignment" parameter should be one of these 3 values "threat", "helpful", and "neutral"
  #   Your response should be in JSON format 
  #   EOT
  #   #add alterior motives loot aand secrets later
  # end



  #has a tag

  #label: , type creature, completion, alignment: hostile

  #creature_type
  #description
  #name
  #special_abilities
  #quantity
  #weaknesses
  #items
  #alignment -> a threat, helpful, neutral
  #motive
  #tactics
  #bonuses
  #hp
  #secrets

  
  
  private
 
end