class RollTable < ApplicationRecord
  store_accessor :completion
 
   
  belongs_to :user

  has_many :quest_connections,
  foreign_key: :roll_table_id,
  class_name: "QuestsRollTable",
  primary_key: :id
  
  has_many :quests, through: :quest_connections


   has_many :field_connections,
   foreign_key: :roll_table_id,
   class_name: "FieldsRollTable",
   primary_key: :id

  has_many :fields, through: :field_connections



  include Generatable

  def prompt(params)
    #scene context should prepend a quest context too
    #context model.find_by()
    #params[:context]
    prompt_str = <<~EOT 
    Create a roll-table of #{table_type.pluralize} with #{row_count} entries for use with a table-top-rpg
    With this relevant context "#{self.context}"
    Each entry should be represented by an integer and have at least 1 parameter
    Your response should be in the format of a JSON hash.
    EOT
  end

  #  Each entry should be represented by a number and have #{column_array.length} parameters #{column_string} 
  #

  def column_string
    last = column_array.slice!(-1)
    column_array.join(", ") + ", and " + last
  end

  def column_array
    keys = completion["1"].keys
    keys
  end


  # def columns
  #   inner_keys = first_entry.keys
  #   inner_keys.join("/")
  # end

  # def first_entry
  #   entry_hash = completion.first.last
  # end

end
