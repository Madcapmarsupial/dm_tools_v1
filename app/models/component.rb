class Component < ApplicationRecord
  belongs_to :field,
    optional: :true

  #belongs to field
  #has many details
  include Generatable

  

  def self.get_type
    itself.to_s.downcase
  end

  def child_type
    "detail"
  end

  def get_type
    self.class.get_type
  end
  


  def self.get_class(type)
    #more genralized?
      #creature #item #effect #information

    fields = {
      "creature" => Creature,
      "reward" => Reward,  #item
      "special_mechanic" => SpecialMechanic,
      "active_effect" => ActiveEffect
       #datum => Datum
    }
    fields[type.downcase]
  end






   def self.prompt(params)
    scene = Scene.find_by(id: params[:field_id])
    parents_context = scene.context_for_component
    #scene.creature_context    # component_context
    #
    #build context
    if params[:alignment] != ""
      alignment_string = <<~EOT
      Make this #{get_type} #{params[:alignment]} to the player characters 
      label it using the "alignment" parameter
      EOT
    else
      alignment_string = ""
    end

    <<~EOT
    In the context of the below rpg scenario and the specified scene
    #{parents_context}
    The "#{get_type}" named #{params[:name]} 
    Recreate this #{get_type} in more detail 
    The #{get_type} should have #{param_list.length} parameters #{param_string}
    #{alignment_string} 
    The "alignment" parameter should be one of these 3 values "harmful", "helpful", or "neutral"
    Your response should be in JSON format 
    EOT
  end

  def self.param_list
    stored_attributes[:completion]
  end

  def self.param_string   
    param_list.slice(0...-1).join(", ") + " and #{param_list.last}"
  end
  
  



end