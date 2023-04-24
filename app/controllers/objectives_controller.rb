class ObjectivesController < ApplicationController
  def new
    @quest = Quest.find_by(id: params[:quest_id])
    @objective = Objective.new(quest_id: @quest.id, completion: {})
    #2.times { @objective.creatures.build }
    render :new
      # render "#{type.pluaralize}/new"  
  end

  def create
    quest_id = objective_params[:quest_id] #quest_id = params[:field][:quest_id] 
    @objective = Objective.new(objective_params)
    @objective.name = params[:objective][:completion]["objective_name"].titleize

    if @objective.save
      redirect_to objective_url(@objective.id)
    else
      redirect_to quest_url(quest_id), alert: @objective.errors.full_messages
    end
  end

  def show
    @objective = Objective.find_by(id: params[:id])
    #rework this to redirect to the type/show?
    # render fields/ show and pass in the type on view to detrmine which "type partial to render?"
    @objective
    #render "#{@field.type.downcase}_show", field: @field
  end

  def edit
    @objective = Objective.find_by(id: params[:id])
    render :edit
  end

  def update 
    #quest_id = params[:field][:quest_id] #[:encounter][:quest_id]
    @objective = Objective.find_by(id: params[:id])
    @objective.name = params[:objective][:completion]["objective_name"].titleize

    #objective_params[:name] = params[:objective][:completion]["objective_name"].titleize
    if @objective.update(objective_params)
      redirect_to objective_url(@objective.id)
    else
      redirect_to quest_url(quest_id), alert: @objective.errors.full_messages
    end
  end

  def generate
    @objective = Objective.find_by(id: params[:id])  
    begin 
      prompt_str = Objective.prompt(params[:objective])
      values = create_completion("objective", prompt_str)
      if @objective.update(values)
        redirect_to objective_url(@objective.id)
      else
        @objective.errors.add :response, invalid_response: "#{values.errors.full_messages}"
        redirect_to quest_url(@objective.quest_id), alert: @objective.errors.full_messages
      end
    rescue StandardError => e
      redirect_to root_path, alert: e
    end
  end

  include Generatable

  private
  def objective_params
    params.require(:objective).permit(:name, :quest_id, :response_id, :type, completion: Objective.param_list 
      # creatures_attributes:[:id, :type, :description, :name, :quantity, :alignment, :completion]
      ) #field_id
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