class Add < ActiveRecord::Migration[7.0]
  def change
    add_reference :components, :response, foreign_key: true
  end
end
