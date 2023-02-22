class Trait < ApplicationRecord
  belongs_to :parent,
    class_name: 'Field',
    primary_key: :id,
    foreign_key: :field_id
end