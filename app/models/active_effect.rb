class ActiveEffect < Component
  belongs_to :encounter,
  class_name: 'Encounter',
  foreign_key: :field_id,
  primary_key: :id,
  dependent: :destroy
  #has mnay details

  store_accessor :completion, [:name, :description, :alignment,
  :duration_in_rounds, :effect, :cause, :prevention, :secrets, :lore, :appearance, :defense]

    #:special_abilities, :key_chracteristic, :personality, :motivation, :alignment, :tactics]
 
  #listable
  
  # if params[:alignment] != ""
  #     alignment_string = <<~EOT
  #     Make this #{get_type} #{params[:alignment]} to the player characters 
  #     label it using the "alignment" parameter
  #     EOT
  #   else
  #     alignment_string = ""
  #   end

  #   <<~EOT
  #   In the context of the below rpg scenario and the specified encounter
  #   #{parents_context}
  #   The "#{get_type}" named #{params[:name]} 
  #   Recreate this #{get_type} in more detail 
  #   The #{get_type} should have #{param_list.length} parameters #{param_string}
  #   #{alignment_string} 
  #   The "alignment" parameter should be one of these 3 values "harmful", "helpful", or "neutral"
  #   #{specifics_string}
  #   Your response should be in JSON format 
  #   EOT

  def self.get_type
    "active_effect"
  end

end