class ItemsController < ApplicationController
  include Generatable

  def new
    parent_id = get_parent_id(params)
    @field = Field.find_by(id: parent_id)
    @item = Item.new(field_id: @field.id, completion: {})

    render :new
  end

  def create
    @item = Item.new(item_params)
    @item.name = item_params[:completion][:item_name].titleize 
    @item.component_alignment = item_params[:completion][:alignment]
    @item.desc = item_params[:completion][:description]
    @item.field_id = item_params[:field_id]
   
    if @item.save
      if params[:submit] == "generate" 
          params[:id] = @item.id
            #add created component's id to the params    
          generate
            #call to generate action
      else
          redirect_to item_url(@item.id)
        end
    else
      redirect_to field_url(field_id), alert: @item.errors.full_messages
    end
  end

  def show
    @item = Item.find_by(id: params[:id])
    @item
  end

  def edit
    @item = Item.find_by(id: params[:id])
    render :edit
  end

  def update 
    @item = Item.find_by(id: params[:id])
    @item.name = item_params[:completion][:item_name].titleize
    @item.component_alignment = item_params[:completion][:alignment]
    @item.desc = item_params[:completion][:description]

    if @item.update(item_params)
      if params[:submit] == "generate"
        generate
      else
        redirect_to item_url(@item)
      end
    else
      redirect_to quest_url(quest_id), alert: @item.errors.full_messages
    end
  end

  def generate
   @item = Item.find_by(id: params[:id]) 
    begin  
      prompt_str = Item.prompt(@item)
      values = create_completion("item", prompt_str)
      if @item.update(values)
        redirect_to item_url(@item.id)
      else
        @item.errors.add :response, invalid_response: "#{values.errors.full_messages}"
        redirect_to quest_url(@item.quest_id), alert: @item.errors.full_messages
      end
    rescue StandardError => e
      redirect_to root_path, alert: e
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :desc, :component_alignment, :type, :field_id, :quantity, completion: {})
  end

  PARENTS = ["scene_id", "villain_id", "setting_id", "objective_id", "field_id"]

  def get_parent_id(params)
    PARENTS.each { |type_id| return params[type_id] if params[type_id] != nil}
  end
end