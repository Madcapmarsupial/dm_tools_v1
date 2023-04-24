class ComponentsController < ApplicationController
  def index 
    field = Field.find_by(id: component_params[:field_id] 
    type_str = component_params[:type]
    @components = field.components.where(type: type_str)

    render :index
  end
  
  def new
    class_type = params[:component][:type]
    subclass = Component.get_class(class_type)
    @field = Field.find_by(id: params[:field_id])
    @component = subclass.new(field_id: @field.id, completion: {})

    render :new
  end

  def create
    field_id = params[:component][:field_id])
    class_type = params[:component][:type]
    subclass = Component.get_class(class_type)

    @component = subclass.new(component_params)

    if @component.save
      redirect_to component_url(@component.id)
    else
      redirect_to field_url(field_id), alert: @component.errors.full_messages
    end
  end

  def show
    @component =  Component.find_by(id: params[:id])
    render "show", component: @component
  end
  
  def edit
    @component = Component.find_by(id: params[:id])
    render :edit
  end

  def update 
    @component = Component.find_by(id: params[:id])
    type_str = @component.class.get_type
    fail

    if @component.update(name: params[:component][:completion]["#{type_str}_name"].titleize, completion: params[:component][:completion])
      redirect_to component_url(@component.id)
    else
      redirect_to field_url(@component.field_id), alert: @component.errors.full_messages
    end
  end








  def generate
    @component = Component.find_by(id: params[:id])   
    prompt_str = @component.class.prompt(params[:component])
    component_type = @component.class.get_type
    values = create_completion(component_type, prompt_str)
    if @component.update(values)
      redirect_to component_url(@component.id)
    else
      @component.errors.add :response, invalid_response: "#{values.errors.full_messages}"
      redirect_to field_url(@component.field_id), alert: @component.errors.full_messages
    end
  end

  include Generatable

  private
   def component_params
    params.require(:component).permit(:name, :description, :alignment, :type, :field_id, :quantity)
   end
  #single_component_params

  # def create_response(prompt)
  #   response = Response.build_response(prompt, current_user.id)  #$$$ inside Response      
  # end







end