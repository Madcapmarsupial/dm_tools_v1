class Setting < Field
  attr_accessor :where 

  def queue
    @queue ||= ['where'] #secrets #inhabited #interior #hotsile
 end

 def set_label
  if queue.empty?
    'empty'
  else
    self.queue.shift
  end
 end


  # def edge
  #   @edge ||= Trait.new(label: 'edge',field_id: self.id)
  # end 
  def where
    @where ||= Trait.create(label: 'where', field_id: self.id)
  end

  def create_traits
    [where]
  end

end
