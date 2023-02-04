class Quest < ApplicationRecord
  attr_accessor :villain, :timer, :twist, :setting, :objective


  has_many :fields,
  dependent: :destroy

  has_many :children,
  through: :fields,
  source: :children
  
  #has_many :traits,
  #through fields,
  #source traits

  def last_created_field
    list = self.fields
    result = list.order(created_at: :desc).first
    if result == nil
      result = Field.new
    end
    result
  end

  def villain
    @villain ||= Villain.create(label: 'person', value: 'villain', quest_id: self.id)
  end 

  def timer
    @timer ||= Timer.create(label: 'thing', value: 'timer', quest_id: self.id)
  end 

  def twist
    @twist ||= Twist.create(label: 'thing', value: 'twist', quest_id: self.id)
  end 

  def setting
    @setting ||= Setting.create(label: 'place', value: 'setting', quest_id: self.id)
  end 

  def objective
    @objective ||= Oqbjective.create(label: 'thing', value: 'objective', quest_id: self.id)
  end 

  def set_pointer
    #returns the label field that should be created next
    queue[last_created_field.label] || 'setting'
  end

  def queue
    {'setting' => 'villain', 'villain' => 'goal'}
  end


end
