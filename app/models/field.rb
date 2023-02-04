class Field < ApplicationRecord
   #deleteing a field will delete all the sub fields associated with it
  has_many :children,
  class_name: 'Trait',
  dependent: :destroy,
  primary_key: :id,
  foreign_key: :field_id
   
  belongs_to :quest,
  primary_key: :id,
  foreign_key: :quest_id
  

    def last_created_trait
      list = self.children
      list.order(created_at: :desc).first
    end


  def set_pointer
    #returns the label field that should be created next
    #overide this to set a default?
    queue[last_created_triat.label] || 'empty'
  end

  def queue
    #each subclass must overide the method with its own queue
    'empty'
  end

 
  #get all child sub_fields
  #get parent quest 

    #   def create_phase_one_villain_traits
    #    traits = [
    #      Trait.new(label: 'tragic backstory', field_id: self.id),
    #      Trait.new(label: 'who or what', field_id: self.id),
    #      Trait.new(label: 'henchman', field_id: self.id),
    #      Trait.new(label: 'endgoal', field_id: self.id),
    #      Trait.new(label: 'edge',field_id: self.id),
    #      Trait.new(label: 'lair', field_id: self.id)      
    #    ]
    #  end

    


end