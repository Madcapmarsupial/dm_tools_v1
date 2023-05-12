class QuestsRollTable < ApplicationRecord
  belongs_to :quest, class_name: "Quest"
  belongs_to :roll_table, class_name: "RollTable"

end