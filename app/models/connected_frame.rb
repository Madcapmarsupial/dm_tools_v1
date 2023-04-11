class ConnectedFrame < ApplicationRecord
  belongs_to :parent, class_name: 'Frame'
  belongs_to :child, class_name: 'Frame'
end