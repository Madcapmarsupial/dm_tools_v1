class TraitsController < ApplicationController
  #queue must be defined for each feild subclass

  def index
    field = Field.find_by(id: params[:field_id])
    render json: field.children
  end

  def show 
    @trait = Trait.find_by(id: params[:id])
    render :show
  end 

  def new_villain_trait
    #label will need to be dynamic
    # a set label function
    #for traits we will need to check the parent label. maybe the last used trait?

    #parent = Field.find_by(id: params[:field_id])

    @trait = Trait.new(field_id: params[:field_id], label: 'some value' )
    render :new
  end

  def new #first_trait
    #will we need to do Filter by specicif sublcass? VIllain/timer etc--> looks like
    #could use label to do so.
    # case    when "villain" then  Villain.find_by 
    #add more tables? 
    #polymorphic fields?

    @field = Field.find_by(id: params[:field_id])
    last_label = @field.last_created_trait.label
    
    #self.class == Villain...Timer etc
    @queue = @feild.queue
    #pointer will be the new label
    @pointer = @feild.set_pointer




    @trait = Trait.new(field_id: params[:field_id], label: 'empty' )
    render :new
  end

  def create
    @trait = Trait.new(trait_params)
    #trait_params  will be users inputs + the mandetory inputs

    if @trait.save
      #render json: @trait
      redirect_to @trait
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

  def set_pointer
    #self.queue
  end
end



