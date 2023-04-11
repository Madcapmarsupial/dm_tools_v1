class FieldsController < ApplicationController

  def create
    quest_id = params[:field][:quest_id] #[:encounter][:quest_id]
    subclass = Field.get_class(params[:field][:type])
    @field = subclass.new(quest_id: quest_id, name: params[:field][:name].titleize)

    if @field.save
      redirect_to field_url(@field.id)
    else
      redirect_to quest_url(quest_id), alert: @field.errors.full_messages
    end
  end

  def show
    field = Field.find_by(id: params[:id])
    @field = Field.get_class(field.type.downcase).find_by(id: params[:id])
    #rework this to redirect to the type/show?
    # render fields/ show and pass in the type on view to detrmine which "type partial to render?"
    render "show", field: @field
    #render "#{@field.type.downcase}_show", field: @field
  end


  
  def generate
    #need this outside begin loop so we have an id to redirect_to
    @field = Field.find_by(id: params[:id])   
#    begin
      #if current_user.has_enough_bottlecaps? 
        #subclass = Field.get_class(params[:field][:type])
          #get glass type in order to get appropriate prompt
        #prompt_str = subclass.prompt(params[:field])
        prompt_str = @field.class.prompt(params[:field])
        field_type = @field.class.get_type
        #response = create_response(prompt_str) 
        values = create_completion(field_type, prompt_str)
        #type_name = "#{field_type}_name"

        #values = {response_id: response.id, completion: response.text_to_hash, name: response.text_to_hash[type_name]} 

        if @field.update(values)
          #if we reach this point the validations have all passed
          #redirect_to quest_url(quest_id)
          redirect_to field_url(@field.id)
        else
          @field.errors.add :response, invalid_response: "#{values.errors.full_messages}"
          redirect_to quest_url(@field.quest_id), alert: @field.errors.full_messages
            #quest not saved   #refund_user?/salvage last response
            #refund
        end
      #else
       #   redirect_to quest_url(quest_id), notice: "insufficient coins"
          #redirect_to  add coins 
      #end
    #rescue StandardError => e
      #redirect_to quest_url(@field.quest_id), alert: e
    #end

  end











  # def update
   #  @encounter = Encounter.find_by(id: params[:id])
   #  #what type of update?
   #  #update completion
   #    #control flow to decide what type of update params to call
   #   new_completion = @encounter.add_component(component_params)
   #      #component = {name = val, description = val}
   #  #save might be better
   #  #add validations
   #  if @encounter.update(completion: new_completion)
   #    redirect_to @encounter
   #  else
   #    redirect_to @field, alert: @encounter.errors.full_messages
   #  end
  # end

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