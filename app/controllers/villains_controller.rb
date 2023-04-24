class VillainsController < ApplicationController
  def new
    @quest = Quest.find_by(id: params[:quest_id])
    @villain = Villain.new(quest_id: @quest.id, completion: {})
    #2.times { @villain.creatures.build }
    render :new
      # render "#{type.pluaralize}/new"  
  end

  def create
    quest_id = villain_params[:quest_id] #quest_id = params[:field][:quest_id] 
    @villain = Villain.new(villain_params)
    @villain.name = params[:villain][:completion]["villain_name"].titleize

    if @villain.save
      redirect_to villain_url(@villain.id)
    else
      redirect_to quest_url(quest_id), alert: @villain.errors.full_messages
    end
  end

  def show
    @villain = Villain.find_by(id: params[:id])
    #rework this to redirect to the type/show?
    # render fields/ show and pass in the type on view to detrmine which "type partial to render?"
    @villain
    #render "#{@field.type.downcase}_show", field: @field
  end

  def edit
    @villain = Villain.find_by(id: params[:id])
    render :edit
  end

  def update 
    #quest_id = params[:field][:quest_id] #[:encounter][:quest_id]
    @villain = Villain.find_by(id: params[:id])
    @villain.name = params[:villain][:completion]["villain_name"].titleize

    #villain_params[:name] = params[:villain][:completion]["villain_name"].titleize
    if @villain.update(villain_params)
      redirect_to villain_url(@villain.id)
    else
      redirect_to quest_url(quest_id), alert: @villain.errors.full_messages
    end
  end

  def generate
    @villain = Villain.find_by(id: params[:id]) 
    begin  
      prompt_str = Villain.prompt(params[:villain])
      values = create_completion("villain", prompt_str)
      if @villain.update(values)
        redirect_to villain_url(@villain.id)
      else
        @villain.errors.add :response, invalid_response: "#{values.errors.full_messages}"
        redirect_to quest_url(@villain.quest_id), alert: @villain.errors.full_messages
      end
    rescue StandardError => e
      redirect_to root_path, alert: e
    end
  end

  include Generatable

  private
  def villain_params
    params.require(:villain).permit(:name, :quest_id, :response_id, :type, completion: Villain.param_list 
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