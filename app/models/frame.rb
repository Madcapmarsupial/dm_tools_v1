class Frame < ApplicationRecord
  has_many :parent_frames, foreign_key: :parent_id, class_name: 'ConnectedFrame'
  
  has_many :parents, through: :child_frames
  
  has_many :child_frames, foreign_key: :child_id, class_name: 'ConnectedFrame'
  has_many :children, through: :parent_frames


  belongs_to :scene,
    foreign_key: :field_id
  


  def connect_frame(frame_id)
    ConnecetedFrame.create(parent_id: self.id, child_id: frame_id)
  end
end