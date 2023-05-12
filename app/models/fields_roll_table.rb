class FieldsRollTable < ApplicationRecord
  belongs_to :field, class_name: "Field"
  belongs_to :roll_table, class_name: "Roll_table"

end