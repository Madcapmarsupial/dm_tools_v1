class SpecialMechanic < Component
  belongs_to :encounter,
  class_name: 'Encounter',
  foreign_key: :field_id,
  primary_key: :id,
  dependent: :destroy
  #has mnay details

  store_accessor :completion, [:name, :description, :alignment, :duration_in_rounds, :effect, :trigger, 
    :defense, :secrets, :lore, :appearance]
    #, :quantity, :weaknesses,:equipment, 
    #:special_abilities, :key_chracteristic, :personality, :motivation, :alignment, :tactics]
  #:duration_in_rounds, :effect, :cause, :prevention, :secrets, :lore, :appearance, :defense]
    #
 
  #listable
  
  def self.get_type
    "special_mechanic"
  end
 
end