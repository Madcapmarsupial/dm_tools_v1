class Trait < ApplicationRecord
  belongs_to :parent,
    class_name: 'Field',
    primary_key: :id,
    foreign_key: :field_id
 
 


    def set_pointer 
      label_list = {
        'who' => 'edge',
        'edge' => 'henchman',
        'henchman' => 'backstory', 
        'backstory' => 'lair',
        'lair' => 'who'
      }
      next_label = label_list[self.label]
      next_label
    end 
end