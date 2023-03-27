class FieldsController < ApplicationController
    
  def create
    quest_id = params[:field][:quest_id]#[:encounter][:quest_id]

    begin
      if current_user.has_enough_bottlecaps?  #check user balance
        field_name = params[:field][:name]#[:encounter][:name]
        
        field_prompt = Field.get_class(params[:field][:type]).prompt({"quest_id" => quest_id, "name"=> field_name, "desc"=>params[:field][:description]})
        #we use the class specific prompt -e Villain.prompt
        #name passed via params in view

        response = create_response(field_prompt)  #user charged --> calls Response.create
        #possibility that the response is (new) and invalid

        #values = {response_id: response.id, completion: response.text_to_hash, quest_id: quest_id, name: encounter_name}
        #@encounter = Encounter.new(values)

        values = {response_id: response.id, completion: response.text_to_hash, quest_id: quest_id, name: field_name} 
        @field = Field.get_class(params[:field][:type]).new(values)

        if @field.save
          #if we reach this point the validations have all passed
          
          #redirect_to @field #points to created type
          redirect_to quest_url(quest_id)

        else
          #refund -> and render :new #redirect_to user_home  #render response.errors.full_messaged too?
          @field.errors.add :response, invalid_response: "#{response.errors.full_messages}"
          #render json: @quest.errors.full_messages, status: :unprocessable_entity
          redirect_to quest_url(quest_id), alert: @field.errors.full_messages
            #quest not saved   #refund_user?/salvage last response
        end
      else
          redirect_to quest_url(quest_id), notice: "insufficient bottle caps"
          #"insufficient funds"
      end
    rescue StandardError => e
      redirect_to quest_url(quest_id), alert: e
    end
  end

  def show
    @field = Field.find_by(id: params[:id])
    #rework this to redirect to the type/show?
    # render fields/ show and pass in the type on view to detrmine which "type partial to render?"
    render "show", field: @field
  end

  # def update
  #   @encounter = Encounter.find_by(id: params[:id])
  #   #what type of update?
  #   #update completion
  #     #control flow to decide what type of update params to call
  #    new_completion = @encounter.add_component(component_params)
  #       #component = {name = val, description = val}
  #   #save might be better
  #   #add validations
  #   if @encounter.update(completion: new_completion)
  #     redirect_to @encounter
  #   else
  #     redirect_to @field, alert: @encounter.errors.full_messages
  #   end
  # end




  private
  # def encounter_params
  #   params.require(:encounter).permit(:name, :quest_id, :completion, :response_id, :type)
  # end

  def component_params
   params.require(:component).permit(:type, :description, :name)
  end
  #this could go on a parent controller with the bottle cap check
  def create_response(prompt)
    #filters  the output of the Response create to load into a new quest
    response = Response.build_response(prompt, current_user.id)  #$$$ inside Response     
  end

end