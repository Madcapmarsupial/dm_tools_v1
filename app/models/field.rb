class Field < ApplicationRecord
  #objective, villain, plotwist, encounter, location, setting/location, roll table
  #custom_field       description (or this as part of setting?)

  belongs_to :quest,
  optional: true,
  foreign_key: :quest_id,
  primary_key: :id,
  dependent: :destroy

  belongs_to :response,

  class_name: "Response",
  foreign_key: :response_id,
  primary_key: :id

   
  def self.get_class(type)
    fields = {
      "encounter" => Encounter,
      "villain" => Villain,
      "timer" => Timer,
      "location" => Location,
      "plotwist" => Plotwist,
      "objective" => Objective
    }
    fields[type.downcase]
  end

  def self.prompt(options)
    quest = Quest.find_by(id: options["quest_id"])

    <<~EOT
    #{quest.context}
    Recreate "#{options["name"]}" in more detail.
    Your response should have #{param_list.length} parameters #{param_string}
    Your response should be in JSON format
    EOT
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