class Detail < ApplicationRecord
   #self reference 
    has_many :connections_to_children, 
    foreign_key: :parent_detail_id,
    class_name: 'ConnectedDetail'

     has_many :child_details, through: :connections_to_children



     has_many :connections_to_parents,
     foreign_key: :child_detail_id, 
     class_name: 'ConnectedDetail'

     has_many :parent_details, through: :connections_to_parents
  #

    has_many :quest_details,
    foreign_key: :detail_id

    has_many :quests,  #might be better j
    through: :quest_details

   def connect_detail(detail_id)
    ConnectedDetail.create(parent_detail_id: self.id, child_detail_id: detail_id)
   end
end