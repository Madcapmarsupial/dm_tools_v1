class Field < ApplicationRecord
  #objective, villain, plotwist, encounter, location, setting/location, roll table
  #custom_field       description (or this as part of setting?)

  belongs_to :quest,
  foreign_key: :quest_id,
  primary_key: :id,
  dependent: :destroy

  belongs_to :response,
  class_name: "Response",
  foreign_key: :response_id,
  primary_key: :id

   
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