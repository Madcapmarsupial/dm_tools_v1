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

    types = {
      "creature" => Creature,
      "item" => Item,  #item
      "reward" => Item,
      "effect" => Effect,
      "active_effect" => Effect,
      "ability" => Effect,
      "special_mechanic" => Effect
       #datum => Datum
    }
    types[type.downcase]
  end

  def self.prompt(component)
    parent = Field.find_by(id: component.field_id)
    parents_context = parent.context_for_component
    #scene.creature_context    # component_context
    #
    #build context
    if component.component_alignment != "" && component.component_alignment != nil
      alignment_string = <<~EOT
      Make this #{get_type} #{component.component_alignment} to the player characters 
      Label it using the "alignment" parameter
      EOT
    else
      alignment_string = ""
    end

    if component.desc != "" && component.desc != nil
      desc_string = <<~EOT
      based off this description "#{component.desc}"
      EOT
    else
      desc_string = ""
    end

    <<~EOT
    #{parents_context}
    Create this #{get_type} with the name #{component.name} 
    #{desc_string}
    The #{get_type} should have #{param_list.length} parameters #{param_string}
    #{alignment_string} 
    The "alignment" parameter should be one of these 3 values "harmful", "helpful", or "neutral"
    Your response should be in JSON format 
    EOT
  end


  def hidden_keys
    ["alignment", "description", "#{self.get_type}_name"]
  end


  

  #context
  #body
  #specifics


  #create this {component.type} for a table-top-rpg sceneario that is represented by the following hash. {context}
  #{component.type.specifics}

  def self.param_list
    stored_attributes[:completion]
  end

  def self.param_string   
    param_list.slice(0...-1).join(", ") + " and #{param_list.last}"
  end
  
  



end