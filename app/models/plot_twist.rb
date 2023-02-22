class PlotTwist < Field

  def set_pointer
    self.queue[last_created_trait.label] || 'empty' #'lie'
  end

    #type -> person place thing
    #secret


  def queue
    {'empty' => 'empty'}
    # {'lie' => 'liar', 'liar' => "truth", 
    # "truth" => 'empty'}  
  end

  #fetch other fields to fill sort by those with the same type or label ?
  #prompt for new field for truth ? with filtered params?
end