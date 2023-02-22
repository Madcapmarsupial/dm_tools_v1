class TraitsController < ApplicationController
  #queue must be defined for each feild subclass

  def index
    field = Field.find_by(id: params[:field_id])
    render json: field.children
  end

  def show 
    @trait = Trait.find_by(id: params[:id])

      #@field = Field.find_by(id: @trait.field_id)
      # @queue = @field.queue
      # @pointer = @queue[@trait.label]

      @field = @trait.parent
      @queue = @field.queue
      @pointer = @field.set_pointer

      if @pointer == 'empty'   # we may have to set this to one before empty?
        #returns to parent -> field->show action
        redirect_to field_url(@field.id)
      else 
        #continues queue of traits
        #redirect instead of render because this will be a new trait
        redirect_to new_field_trait_url(@field.id)
      end
  end 

  def new #first_trait
    #last_label = @field.last_created_trait.label
    @field = Field.find_by(id: params[:field_id])
    @queue = @field.queue
    #pointer will be the new label
    @pointer = @field.set_pointer

    @trait = Trait.new(field_id: params[:field_id])
    render :new
  end

  def create
    @trait = Trait.new(trait_params)

    if @trait.save
      redirect_to trait_url(@trait)
    else
      render json: @trait.errors.full_messages, status: :unprocessable_entity
    end
  end

  def edit 
    #id needs to be in the route
    @trait = Trait.find_by(id: params[:id])
    render :edit 
  end

  def update
    @trait = Trait.find_by(id: params[:id])
    #.new(trait_params)

    if @trait.update(trait_params)
      @trait
      render :show
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    trait = Trait.find(params[:id])
    if trait.destroy
      render json: trait
    else 
      render json: trait.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
  def trait_params
    params.require(:trait).permit(:value, :label, :note, :field_id)
  end

  
end



