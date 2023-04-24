class EffectsController < ApplicationController
  include Generatable

  def new
    parent_id = get_parent_id(params)
    @field = Field.find_by(id: parent_id)
    @effect = Effect.new(field_id: @field.id, completion: {})
    render :new
  end

  def create
    @effect = Effect.new(effect_params)
    @effect.name = effect_params[:completion][:effect_name].titleize 
    @effect.component_alignment = effect_params[:completion][:alignment]
    @effect.desc = effect_params[:completion][:description]
    @effect.field_id = effect_params[:field_id]
   
    if @effect.save
      if params[:submit] == "generate" 
          params[:id] = @effect.id
            #add created component's id to the params    
          generate
            #call to generate action
      else
          redirect_to effect_url(@effect.id)
        end
    else
      redirect_to field_url(field_id), alert: @effect.errors.full_messages
    end
  end

  def show
    @effect = Effect.find_by(id: params[:id])
    @effect
  end

  def edit
    @effect = Effect.find_by(id: params[:id])
    render :edit
  end

  def update 
    @effect = Effect.find_by(id: params[:id])
    @effect.name = effect_params[:completion][:effect_name].titleize
    @effect.component_alignment = effect_params[:completion][:alignment]
    @effect.desc = effect_params[:completion][:description]

    if @effect.update(effect_params)
      if params[:submit] == "generate"
        generate
      else
        redirect_to effect_url(@effect)
      end
    else
      redirect_to quest_url(quest_id), alert: @effect.errors.full_messages
    end
  end

  def generate
   @effect = Effect.find_by(id: params[:id]) 
    begin  
      prompt_str = Effect.prompt(@effect)
      values = create_completion("effect", prompt_str)
      if @effect.update(values)
        redirect_to effect_url(@effect.id)
      else
        @effect.errors.add :response, invalid_response: "#{values.errors.full_messages}"
        redirect_to quest_url(@effect.quest_id), alert: @effect.errors.full_messages
      end
    rescue StandardError => e
      redirect_to root_path, alert: e
    end
  end

  private
  def effect_params
    params.require(:effect).permit(:name, :desc, :component_alignment, :type, :field_id, :quantity, completion: {})
  end

  PARENTS = ["scene_id", "villain_id", "setting_id", "objective_id", "field_id"]

  def get_parent_id(params)
    PARENTS.each { |type_id| return params[type_id] if params[type_id] != nil}
  end
end