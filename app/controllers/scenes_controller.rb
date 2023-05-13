class ScenesController < ApplicationController
  
  def index
    @quest = Quest.find_by(id: params[:quest_id])
    @scenes = @quest.scenes
    #2.times { @scene.creatures.build }
    render :index
  end
  
  def new
    @quest = Quest.find_by(id: params[:quest_id])
    @scene = Scene.new(quest_id: @quest.id, completion: {})
    #2.times { @scene.creatures.build }
    render :new
  end



  def create
    quest_id = scene_params[:quest_id] 
    @scene = Scene.new(scene_params)
    @scene.name = params[:scene][:completion]["scene_name"].titleize

    if @scene.save
      #create order_number
      redirect_to scene_url(@scene.id)
    else
      redirect_to quest_url(quest_id), alert: @scene.errors.full_messages
    end
  end

  def show
    @scene = Scene.find_by(id: params[:id])
    #rework this to redirect to the type/show?
    # render fields/ show and pass in the type on view to detrmine which "type partial to render?"
    @scene
    #render "#{@field.type.downcase}_show", field: @field
  end

  def edit
    @scene = Scene.find_by(id: params[:id])
    render :edit
  end

  def update 
    @scene = Scene.find_by(id: params[:id])
    @scene.name = params[:scene][:completion]["scene_name"].titleize

    if @scene.update(scene_params)
      redirect_to scene_url(@scene.id)
    else
      redirect_to quest_url(quest_id), alert: @scene.errors.full_messages
    end
  end

  def generate
    begin
      @scene = Scene.find_by(id: params[:id])   
      prompt_str = Scene.prompt(params[:scene])
      values = create_completion("scene", prompt_str)
      if @scene.update(values)
        #create any items effects and creatures generated within the completion
        @scene.build_children
        #@scene.save
        redirect_to scene_url(@scene.id)
      else
        @scene.errors.add :response, invalid_response: "#{values.errors.full_messages}"
        redirect_to quest_url(@scene.quest_id), alert: @scene.errors.full_messages
      end
    rescue StandardError => e
        redirect_to root_path, alert: e
    end
  end

  include Generatable

  private
  def scene_params
    params.require(:scene).permit(:name, :quest_id, :response_id, :type, creatures_attributes:
      [:id, :type, :description, :name, :quantity, :alignment, :completion], completion: Scene.param_list) #field_id
  end

  def component_params
   params.require(:component).permit(:type, :description, :name)
  end

end