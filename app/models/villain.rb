class Villain < Field
  attr_accessor :edge, :endgoal, :lair, :henchman, :backstory, :who
  


  def edge
    @edge ||= Trait.create(label: 'edge',field_id: self.id)
  end 

  def backstory
    @backstory ||= Trait.create(label: 'backstory', field_id: self.id)
  end

  def henchman
    @henchman ||= Trait.create(label: 'henchman', field_id: self.id)
  end

  def endgoal 
    @endgoal ||= Trait.create(label: 'endgoal', field_id: self.id)
  end

  def lair 
    @lair ||= Trait.create(label: 'lair', field_id: self.id)
  end

  def who 
    @who ||= Trait.create(label: 'who', field_id: self.id)
  end

  def create_traits
    [lair, who, endgoal, henchman, edge, backstory]
  end


end