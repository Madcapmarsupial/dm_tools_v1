class Timer < Field
  attr_accessor :fail_condition, :pass_condition

  # def edge
  #   @edge ||= Trait.new(label: 'edge',field_id: self.id)
  # end 
  def fail_condition
    @fail_condition ||= Trait.create(label: 'fail_condition', field_id: self.id)
  end

  def pass_condition
    @pass_condition ||= Trait.create(label: 'pass_condition', field_id: self.id)
  end

  def create_traits
    [fail_condition, pass_condition]
  end

end