class FieldsController < ApplicationController
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
    pointer = @field.type

    t_pointer = @field.set_pointer

     #check the check the quests queue of fields   /field's queue of traits
      if t_pointer == "empty"
          #if the the current fields trait-queue is empty
          if (pointer == 'Custom') || pointer == ('Objective') 
            #if the quests -field-queue is empty
            #go to  quest/show
            redirect_to quest_url(@field.quest_id) 
          else 
             #go to next field in quests queue
            redirect_to new_quest_field_url(@field.quest_id) #fields/new
          end
      else
          redirect_to new_field_trait_url(@field)
      end
  end

  def new
    quest = Quest.find_by(id: params[:quest_id])
    #last_field = quest.last_created_field
    
    @queue = quest.queue #{'setting' => 'villain', 'villain' => 'goal'}
    @pointer = quest.set_pointer #@queue[last_field.label] || 'setting'
    @field = Field.new(quest_id: params[:quest_id])
    render :new
    #on submit points to create
  end

  def create
     @field = Field.new(field_params)

      if @field.save
      #need to go down trait queue

      
       redirect_to field_url(@field)   #show   'currently' [points to quest or next trait]

      else 
       render json: @field.errors.full_messages, status: :unprocessable_entity
      end
  end

  def edit 
  end
  
  def update 
    field = Field.find(params[:id])
    if field.update(field_params)
      render json: field
    else
      render json: field.errors.full_messages, status: :unprocessable_entity
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
  params.require(:field).permit(:quest_id, :value, :label, :type)
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