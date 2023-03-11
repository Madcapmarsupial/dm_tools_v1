class SpecialMechanic < Component
  belongs_to :encounter,
  class_name: 'Encounter',
  foreign_key: :field_id,
  primary_key: :id,
  dependent: :destroy
  #has mnay details

  store_accessor :completion, [:name, :description] #, :quantity, :weaknesses,:equipment, 
    #:special_abilities, :key_chracteristic, :personality, :motivation, :alignment, :tactics]

  #listable
  

  def self.prompt(params)
  end
end