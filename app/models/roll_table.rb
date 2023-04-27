class RollTable < ApplicationRecord
  store_accessor :completion
  
  
  belongs_to :user

  include Generatable

  def prompt(params)
    #scene context should prepend a quest context too
    #context model.find_by()
    #params[:context]
    prompt_str = <<~EOT 
    For a table-top-rpg represented by the following hash #{params[:context]}
    Create a roll-table of #{table_type.pluralize} with #{row_count} entries. 
    Each entry should be represented by a number and have #{column_array.length} parameters #{column_string} 
    Your response should be in the format of a JSON hash.
    EOT
  end

  def column_array
    columns.split("/")
  end

  def column_string
    str = (column_array.slice(0...-1).join(", ") + " and #{column_array.last}")
    str
  end

  def columns
    inner_keys = first_entry.keys
    inner_keys.join("/")
  end

  def first_entry
    entry_hash = completion.first.last
  end

end
