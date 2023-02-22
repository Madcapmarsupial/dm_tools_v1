class Setting < Field
  #attr_accessor :where 

  def set_pointer
    #secrets #inhabited #interior #hotsile
    self.queue[last_created_trait.label] || 'empty'
  end

  def queue
    {'empty' => 'empty'}
  end

 

  # def edge
  #   @edge ||= Trait.new(label: 'edge',field_id: self.id)
  # end 
  

end
