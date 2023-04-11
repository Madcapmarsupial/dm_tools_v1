class Frame < ApplicationRecord
  has_many :parent_frames, foreign_key: :parent_id, class_name: 'Frame'
  has_many :parents, through: :parent_frames
  
  has_many :child_frames, foreign_key: :child_id, class_name: 'Frame'
  has_many :children, through: :child_frames
end