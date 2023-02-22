class Timer < Field
  attr_accessor :fail_condition, :pass_condition

   def set_pointer
    #if its nil -> assigns 'who'
    self.queue[last_created_trait.label] || 'cause'
  end

  def queue #for trait creation order
    {'cause' => 'effect', 'effect' => 'duration',  
     'duration' => 'empty', 'empty' => 'empty' }
  end

end