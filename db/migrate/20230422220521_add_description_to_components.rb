class AddDescriptionToComponents < ActiveRecord::Migration[7.0]
  def change
    add_column(:components, :desc, :string, default: '', null: false)
  end
end
