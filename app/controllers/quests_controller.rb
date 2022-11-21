class QuestsController < ApplicationController
  def index
    @quests = Quest.all
  end

  def create
      @quest = Quest.new(quest_params)

     if @quest.save
       redirect_to @quest
      else 
       render :new, status: :unprocessable_entity
      end
  end

  def show
    @quest = Quest.find(params[:id])
  end

  def new
      p params

    if params.include?('quest')
      @quest = Quest.new(quest_params)
      fields = @quest.attributes.except('id', 'created_at', 'updated_at')
      missing_field = fields.key(nil)

      case missing_field
      when 'location'
        @quest.location = Quest.get_location
      when 'timer'
        @quest.timer = Quest.get_timer
      when 'objective'
        @quest.objective = Quest.get_objective
      when 'villain'
        @quest.villain = Quest.get_villain
      when nil #=> all was passed in to @quest:get_except and which results in no nil values in the attributes hash
        @quest.location = Quest.get_location
        @quest.villain = Quest.get_villain
        @quest.objective = Quest.get_objective
        @quest.timer = Quest.get_timer
      end
      @quest
    else
      @quest = Quest.new #generate_quest
    end
  end
  
  def edit
    @quest = Quest.find(params[:id])

    field = params[:format]
       case field
         when 'location'
           @quest.location = Quest.get_location
         when 'timer'
           @quest.timer = Quest.get_timer
         when 'objective'
           @quest.objective = Quest.get_objective
         when 'villain'
           @quest.villain = Quest.get_villain
         when 'all'
           @quest.location = Quest.get_location
           @quest.villain = Quest.get_villain
           @quest.objective = Quest.get_objective
           @quest.timer = Quest.get_timer
       end

       @quest.update(@quest.attributes)
  end



  def reroll(quest)
    @quest = quest
    @quest.update_attribute(:villain, Quest.get_villain)
      redirect_to :new
  end

   def update
    p 'here'
    p params
    @quest = Quest.find(params[:id])

    if @quest.update(quest_params)
      redirect_to edit_quest_url
    else
      render :edit, status: :unprocessable_entity
    end    
  end

  

  private
    def quest_params
      params.require(:quest).permit(:location, :timer, :villain, :objective)
    end

    #, :timer, :villain, :location, :objective
    #?quest=
end
