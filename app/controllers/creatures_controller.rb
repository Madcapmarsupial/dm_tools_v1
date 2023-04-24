class CreaturesController < ApplicationController
  include Generatable

  def new
    parent_id = get_parent_id(params)
    @field = Field.find_by(id: parent_id)
    @creature = Creature.new(field_id: @field.id, completion: {})

    render :new
  end

  def create
    @creature = Creature.new(creature_params)
    @creature.name = creature_params[:completion][:creature_name].titleize 
    @creature.component_alignment = creature_params[:completion][:alignment]
    @creature.desc = creature_params[:completion][:description]
    @creature.field_id = creature_params[:field_id]
   
    if @creature.save
      if params[:submit] == "generate" 
          params[:id] = @creature.id
            #add created component's id to the params    
          generate
            #call to generate action
      else
          redirect_to creature_url(@creature.id)
        end
    else
      redirect_to field_url(field_id), alert: @creature.errors.full_messages
    end
  end

  def show
    @creature = Creature.find_by(id: params[:id])
    @creature
  end

  def edit
    @creature = Creature.find_by(id: params[:id])
    render :edit
  end

  def update 
    @creature = Creature.find_by(id: params[:id])
    @creature.name = creature_params[:completion][:creature_name].titleize
    @creature.component_alignment = creature_params[:completion][:alignment]
    @creature.desc = creature_params[:completion][:description]

    if @creature.update(creature_params)
      if params[:submit] == "generate"
        generate
      else
        redirect_to creature_url(@creature)
      end
    else
      redirect_to quest_url(quest_id), alert: @creature.errors.full_messages
    end
  end

  def generate
   @creature = Creature.find_by(id: params[:id]) 
    begin  
      prompt_str = Creature.prompt(@creature)
      values = create_completion("creature", prompt_str)
      if @creature.update(values)
        redirect_to creature_url(@creature.id)
      else
        @creature.errors.add :response, invalid_response: "#{values.errors.full_messages}"
        redirect_to quest_url(@creature.quest_id), alert: @creature.errors.full_messages
      end
    rescue StandardError => e
      redirect_to root_path, alert: e
    end
  end

  private
  def creature_params
    params.require(:creature).permit(:name, :desc, :component_alignment, :type, :field_id, :quantity, completion: {})
  end

  PARENTS = ["scene_id", "villain_id", "setting_id", "objective_id", "field_id"]

  def get_parent_id(params)
    PARENTS.each { |type_id| return params[type_id] if params[type_id] != nil}
  end
end