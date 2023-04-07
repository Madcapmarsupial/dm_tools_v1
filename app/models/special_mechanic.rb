class SpecialMechanic < Component
  belongs_to :scene,
  class_name: 'Scene',
  foreign_key: :field_id,
  primary_key: :id,
  dependent: :destroy
  #has mnay details

  store_accessor :completion, [:special_mechanic_name, :description, :alignment, :duration_in_rounds, :effect, :trigger, 
    :defense, :secrets, :lore, :appearance]
    #, :quantity, :weaknesses,:equipment, 
    #:special_abilities, :key_chracteristic, :personality, :motivation, :alignment, :tactics]
  #:duration_in_rounds, :effect, :cause, :prevention, :secrets, :lore, :appearance, :defense]
    #
 
  #listable
  
  def self.get_type
    "special_mechanic"
  end
 
  # * --> {"lore"=>nil, 
  #   "name"=>"The Devil's Bargain",
  #    "effect"=>nil, 
  #    "defense"=>nil, 
  #    "secrets"=>nil, 
  #    "trigger"=>nil, 
  #    "alignment"=>"harmful",
  #     "appearance"=>nil, 
  #     "description"=>"The Hooded Figure will offer the adventurers a deal: 
  #     they can have the cure for the chieftain's son, 
  #     but only if they agree to perform a task for him. 
  #     The task will be dangerous and may involve doing something morally questionable.", "duration_in_rounds"=>nil}


end