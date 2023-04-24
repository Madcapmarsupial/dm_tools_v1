class SettingsController < ApplicationController
  def new
    @quest = Quest.find_by(id: params[:quest_id])
    @setting = Setting.new(quest_id: @quest.id, completion: {})
    #2.times { @setting.creatures.build }
    render :new
      # render "#{type.pluaralize}/new"  
  end

  def create
    quest_id = setting_params[:quest_id] #quest_id = params[:field][:quest_id] 
    @setting = Setting.new(setting_params)
    @setting.name = params[:setting][:completion]["setting_name"].titleize

    if @setting.save
      redirect_to setting_url(@setting.id)
    else
      redirect_to quest_url(quest_id), alert: @setting.errors.full_messages
    end
  end

  def show
    @setting = Setting.find_by(id: params[:id])
    #rework this to redirect to the type/show?
    # render fields/ show and pass in the type on view to detrmine which "type partial to render?"
    @setting
    #render "#{@field.type.downcase}_show", field: @field
  end

  def edit
    @setting = Setting.find_by(id: params[:id])
    render :edit
  end

  def update 
    #quest_id = params[:field][:quest_id] #[:encounter][:quest_id]
    @setting = Setting.find_by(id: params[:id])
    @setting.name = params[:setting][:completion]["setting_name"].titleize

    #setting_params[:name] = params[:setting][:completion]["setting_name"].titleize
    if @setting.update(setting_params)
      redirect_to setting_url(@setting.id)
    else
      redirect_to quest_url(quest_id), alert: @setting.errors.full_messages
    end
  end

  def generate
    @setting = Setting.find_by(id: params[:id])   
    begin
      prompt_str = Setting.prompt(params[:setting])
      values = create_completion("setting", prompt_str)
      if @setting.update(values)
        redirect_to setting_url(@setting.id)
      else
        @setting.errors.add :response, invalid_response: "#{values.errors.full_messages}"
        redirect_to quest_url(@setting.quest_id), alert: @setting.errors.full_messages
      end
    rescue StandardError => e
      redirect_to root_path, alert: e
    end
      
  end

  include Generatable

  private
  def setting_params
    params.require(:setting).permit(:name, :quest_id, :response_id, :type, completion: Setting.param_list
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