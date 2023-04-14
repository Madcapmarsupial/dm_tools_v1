class Frame < ApplicationRecord
  has_many :parent_frames, foreign_key: :parent_id, class_name: 'ConnectedFrame'
  
  has_many :parents, through: :child_frames
  
  has_many :child_frames, foreign_key: :child_id, class_name: 'ConnectedFrame'
  has_many :children, through: :parent_frames
end