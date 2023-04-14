class Frame < ApplicationRecord
  has_many :parent_frames, foreign_key: :parent_id, class_name: 'ConnectedFrame'
  
  has_many :child_frames, foreign_key: :child_id, class_name: 'ConnectedFrame'

  has_many :parents, through: :child_frames
  
  has_many :children, through: :parent_frames


  belongs_to :scene,
    foreign_key: :field_id
  
  def siblings #unlinked
    scene.frames - ((self.parents + self.children) + [self])
  end
  

  def basic_template
  vals = <<~EOT 
    Surroundings:

    Creatures:

    AC's/Targets:

    Loot:

    Ongoing:


    EOT
  end
end