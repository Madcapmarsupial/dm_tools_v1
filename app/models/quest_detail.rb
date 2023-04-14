class QuestDetail < ApplicationRecord
    belongs_to :quest, class_name: 'Quest'
    belongs_to :detail, class_name: 'Detail'
end