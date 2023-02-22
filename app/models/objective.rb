class Objective < Field

  def set_pointer
    self.queue[last_created_trait.label] || 'empty' #'win condition'
  end

    #type -> person place thing
    #secret


  def queue
    #freeze or make a const?
    { 'empty' => 'empty'}  
    # 'win condition' => 'effect of success', 'effect of success' => 'lose condition',
    #   'lose condition' => 'effect of failure', 'effect of failure' => "villain's interest",
    #   "villain's interest" => 'empty',
  end

  #how do we handle villain's use for it
  #add the timer automatically
  #random roll values could live here too
end