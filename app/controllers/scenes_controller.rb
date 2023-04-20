class ScenesController < ApplicationController
  def new
    @quest = Quest.find_by(id: params[:quest_id])
    @scene = Scene.new(quest_id: @quest.id, completion: {})
    render :new
      # render "#{type.pluaralize}/new"
  end

  def create
    quest_id = params[:scene][:quest_id] #quest_id = params[:field][:quest_id] 
    scene_name = params[:field][:completion]["scene_name"].titleize
    @scene = Scene.new(quest_id: quest_id, name: scene_name, completion: params[:scene][:completion])
    fail

    if @scene.save
      redirect_to scene_url(@scene.id)
    else
      redirect_to quest_url(quest_id), alert: @scene.errors.full_messages
    end
  end

  def show
    @scene = Scene.find_by(id: params[:id])
    #rework this to redirect to the type/show?
    # render fields/ show and pass in the type on view to detrmine which "type partial to render?"
    render "show", scene: @scene
    #render "#{@field.type.downcase}_show", field: @field
  end

  def edit
    @scene = Scene.find_by(id: params[:id])
    render :edit
  end

  def update 
    #quest_id = params[:field][:quest_id] #[:encounter][:quest_id]
    @scene = Scene.find_by(id: params[:id])
    fail

    if @scene.update(name: params[:scene][:completion]["scene_name"].titleize, completion: params[:scene][:completion])
      redirect_to scene_url(@scene.id)
    else
      redirect_to quest_url(quest_id), alert: @scene.errors.full_messages
    end
  end

  def generate
    @scene = Scene.find_by(id: params[:id])   
    prompt_str = Scene.prompt(params[:scene])
    values = create_completion("scene", prompt_str)
    if @scene.update(values)
      redirect_to scene_url(@scene.id)
    else
      @scene.errors.add :response, invalid_response: "#{values.errors.full_messages}"
      redirect_to quest_url(@scene.quest_id), alert: @scene.errors.full_messages
    end
  end

  include Generatable

  private
  def scene_params
    params.require(:scene).permit(:name, :quest_id, :completion, :response_id, :type)
  end

  def component_params
   params.require(:component).permit(:type, :description, :name)
  end
  #this could go on a parent controller with the bottle cap check
  #include Generatable

  # def create_response(prompt)
  #   #filters  the output of the Response create to load into a new quest
  #   response = Response.build_response(prompt, current_user.id)  #$$$ inside Response      
  # end

end