class FieldsController < ApplicationController
  def new
    class_type = params[:field][:type]
    subclass = Field.get_class(class_type)
    @quest = Quest.find_by(id: params[:quest_id])
    @field = subclass.new(quest_id: @quest.id, completion: {})
    render :new
      # render "#{type.pluaralize}/new"
  end

  def create
    quest_id = params[:field][:quest_id] #[:encounter][:quest_id]
    subclass = Field.get_class(params[:field][:type])
    field_name = params[:field][:completion]["#{subclass.get_type}_name"].titleize
    @field = subclass.new(quest_id: quest_id, name: field_name, completion: params[:field][:completion])


    fail

    if @field.save
      redirect_to field_url(@field.id)
    else
      redirect_to quest_url(quest_id), alert: @field.errors.full_messages
    end
  end

  def show
    field = Field.find_by(id: params[:id])
    @field = Field.get_class(field.type).find_by(id: params[:id])
    #rework this to redirect to the type/show?
    # render fields/ show and pass in the type on view to detrmine which "type partial to render?"
    render "show", field: @field
    #render "#{@field.type.downcase}_show", field: @field
  end

  def edit
    @field = Field.find_by(id: params[:id])
    render :edit
  end

  def update 
    #quest_id = params[:field][:quest_id] #[:encounter][:quest_id]
    @field = Field.find_by(id: params[:id])
    type_str = @field.class.get_type
    fail

    if @field.update(name: params[:field][:completion]["#{type_str}_name"].titleize, completion: params[:field][:completion])
      redirect_to field_url(@field.id)
    else
      redirect_to quest_url(quest_id), alert: @field.errors.full_messages
    end
  end

  def generate
    @field = Field.find_by(id: params[:id])   
    prompt_str = @field.class.prompt(params[:field])
    field_type = @field.class.get_type
    values = create_completion(field_type, prompt_str)
    if @field.update(values)
      redirect_to field_url(@field.id)
    else
      @field.errors.add :response, invalid_response: "#{values.errors.full_messages}"
      redirect_to quest_url(@field.quest_id), alert: @field.errors.full_messages
    end
  end

  include Generatable

  private
  def component_params
   params.require(:component).permit(:type, :description, :name)
  end

  # def create_response(prompt)
    # add bottle cap check?
   #   #filters  the output of the Response create to load into a new quest
    #   response = Response.build_response(prompt, current_user.id)  #$$$ inside Response     
  # end

  def field_params
    params.require(:field).permit(:type, :description, :name, :options, :completion) #setting_id, objective_id 
  end

end