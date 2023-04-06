class Field < ApplicationRecord
  #objective, villain, plotwist, encounter, location, setting/location, roll table
  #custom_field       description (or this as part of setting?)

  include Generatable  

  belongs_to :quest,
  foreign_key: :quest_id,
  primary_key: :id,
  dependent: :destroy

  belongs_to :response,

  class_name: "Response",
  foreign_key: :response_id,
  primary_key: :id

  def child_type
    "component"
  end


   
  def self.get_class(type)
    fields = {
      "encounter" => Encounter,
      "villain" => Villain,
      "timer" => Timer,
      "setting" => Setting,
      "plotwist" => Plotwist,
      "objective" => Objective
    }
    fields[type.downcase]
  end

  def self.prompt(options)
    quest = Quest.find_by(id: options["quest_id"])

    <<~EOT
    #{quest.q_context}
    Recreate "#{options["name"]}" in more detail.
    Your response should have #{param_list.length} parameters #{param_string}
    Your response should be in JSON format
    EOT
  end

  # def self.blank_context(options)
  #   str = <<~EOT
  #   In an rpg scenario with a #{options["setting"]} as the setting, a #{options["objective"]} as the objective, and a #{options["villain"]} as the villain" 
  #   EOT
  #   str
  # end

# def self.blank_prompt(options)
#   str = <<~EOT
#   #{self.blank_context(options)}
#   create the #{get_type} in more detail.
#   Your response should have #{param_list.length} parameters #{param_string}
#   #{self.specifics}
#   Your response should be in JSON format
#   EOT
#   str
# end

def self.specifics
end

  private
    def self.param_list
      stored_attributes[:completion]
    end

    def self.param_string   
      param_list.slice(0...-1).join(", ") + " and #{param_list.last}"
    end




  
  # def last_created_trait
  #   list = self.children
  #   result = list.order(created_at: :desc).first

  #   if result == nil
  #     result = Trait.new
  #   end
  #   result
  # end

  # def set_pointer
  #   #returns the label field that should be created next
  #   #overide this to set a default?
  #   queue[last_created_trait.label] || 'empty'
  # end

  # def queue
  #   #each subclass must overide the method with its own queue
  #   {'empty' => 'empty'}
  # end

end #class