class Reward < Component
  belongs_to :encounter,
  class_name: 'Encounter',
  foreign_key: :field_id,
  primary_key: :id,
  dependent: :destroy
  #has mnay details

  store_accessor :completion, [:reward_name, :description, :appearance, :quantity, :lore,
  :special_abilities, :active_effects, :secrets, :alignment]

  #listable

  def self.get_type
    "reward"
  end

  # def self.prompt(params)
  #   encounter = Encounter.find_by(id: params[:field_id])
  #   parents_context = encounter.context_for_component
  #   #encounter.creature_context    # component_context
  #   #
  #   #build context
  #   if params[:alignment] != ""
  #     alignment_string = <<~EOT
  #     Make this reward #{params[:alignment]} to the player characters 
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
  #   The #{get_type} should have #{prompt_param_list.length} parameters #{prompt_param_list}
  #   #{alignment_string} 
  #   The "alignment" parameter should be one of these 3 values "harmful", "helpful", and "neutral"
  #   Your response should be in JSON format 
  #   EOT
  # end

  # def prompt_param_list
  #   p_list = self.class.stored_attributes[:completion]
  #   last_key = p_list.last
  #   p_list.slice(0...-1).join(", ") + " and #{last_key}"
  # end
end 