class SpecialMechanic < Component
  belongs_to :scene,
  class_name: 'Scene',
  foreign_key: :field_id,
  primary_key: :id,
  dependent: :destroy
  #has mnay details

  store_accessor :completion, []


  private
    def self.ai_values
      []
    end


end