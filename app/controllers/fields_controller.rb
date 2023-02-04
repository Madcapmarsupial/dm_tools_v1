class FieldsController < ApplicationController

   #new_villain -> who_what
        #who_what -> henchman
         #henchman -> edge
          #edge -> endgoal
            #endgoal -> tragedy
            # tragedy -> lair
              # lair ->   next Field (GOAL)

    #find_by(id: params[:id], label: params[:trait][:label])

  def index
    #temporary
    quest = Quest.find(params[:quest_id])
  
    display = {}
    field_list = quest.fields
    field_list.each do |field| 
      display[field.value] = field.children
    end

    render json: display
    #temporary
  end

  def show 
    @field = Field.find_by(id: params[:id])
    render :show
  end

  def new
    #passed in from the Quest show action (not the view)
    #passed in from link_to?
    #@pointer = params[:pointer]


    quest = Quest.find_by(id: params[:quest_id])
    #last_field = quest.last_created_field
    
    @queue = quest.queue #{'setting' => 'villain', 'villain' => 'goal'}
    @pointer = quest.set_pointer #@queue[last_field.label] || 'setting'

    @field = Field.new(quest_id: params[:quest_id])
    render :new
    #on submit points to create
  end

  def new_setting
    @field = Field.new(quest_id: params[:id], label: 'setting')

    render :new
    #new_setting_quest POST   /quests/:id/new_setting(.:format)    quests#new_setting
    #on submit points to create
  end

  def create
     @field = Field.new(field_params)

      if @field.save
        #set pointer
       redirect_to @field
      else 
        #add label back to front of queue
       render json: @field.errors.full_messages, status: :unprocessable_entity
      end
  end

  def destroy
    field = Field.find(params[:id])
    if field.destroy
      render json: field
    else 
      render json: field.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update 
    field = Field.find(params[:id])
    if field.update(field_params)
      render json: field
    else
      render json: field.errors.full_messages, status: :unprocessable_entity
    end
  end











 def get_who
  @trait = Trait.find_by(field_id: params[:id], label: 'who')

    if @trait.update(inner_trait_params) 
     render json: @trait
    else
       render json: @trait.errors.full_messages, status: :unprocessable_entity
    end
 end
 
 def get_lair  
  @trait = Trait.find_by(field_id: params[:id], label: 'lair')

  if @trait.update(inner_trait_params) 
     render json: @trait
    else
       render json: @trait.errors.full_messages, status: :unprocessable_entity
    end
 end

 def get_henchman
  @trait = Trait.find_by(field_id: params[:id], label: 'henchman') 
  if @trait.update(inner_trait_params) 
     render json: @trait
    else
       render json: @trait.errors.full_messages, status: :unprocessable_entity
    end
 end

 def get_backstory
  @trait = Trait.find_by(field_id: params[:id], label: 'backstory')
  if @trait.update(inner_trait_params) 
     render json: @trait
    else
       render json: @trait.errors.full_messages, status: :unprocessable_entity
    end
 end

 def get_edge
  @trait = Trait.find_by(field_id: params[:id], label: 'edge') 
  if @trait.update(inner_trait_params) 
     render json: @trait
    else
       render json: @trait.errors.full_messages, status: :unprocessable_entity
    end
 end

 def get_endgoal
  @trait = Trait.find_by(field_id: params[:id], label: 'endgoal')
    if @trait.update(inner_trait_params) 
      render json: @trait
    else
      render json: @trait.errors.full_messages, status: :unprocessable_entity
    end
 end

private
def field_params
  params.require(:field).permit(:quest_id, :value, :label)
end  

def inner_trait_params
  params.require(:trait).permit(:field_id, :value, :label, :note)
end







  # def set_as_objective
  #   @objective = Trait.new(field_id: params[:id], label: 'objective', value: params[:value])
  #   #params[:value] -> should be the parent field value
  #   #route it to villain_field, setting_field or an independent_objective_field
  # end

  # def new_connection
  # end

#we would need params to dry this up
#params { id: label: 'who or what'}
# how can we pass in the params 

end