 class ConnectedDetail < ApplicationRecord
  belongs_to :parent_detail, class_name: 'Detail'
  belongs_to :child_detail, class_name: 'Detail'
 end