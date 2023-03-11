class EncountersController < ApplicationController
  
  def create
    if current_user.has_enough_bottlecaps?  #check user balance
      quest_id = params[:encounter][:quest_id]
      encounter_name = params[:encounter][:name]
      e_prompt = Encounter.prompt(quest_id, encounter_name)
      #name passed via params in view

      response = create_response(e_prompt)  #user charged --> calls Response.create
      #possibility that the response is (new) and invalid

      values = {response_id: response.id, completion: response.text_to_hash, quest_id: quest_id, name: encounter_name} #
      @encounter = Encounter.new(values)


      if @encounter.save
        #if we reach this point the validations have all passed
        redirect_to @encounter   #--> quest show
      else
        #refund -> and render :new #redirect_to user_home  #render response.errors.full_messaged too?
        @encounter.errors.add :response, invalid_response: "#{response.errors.full_messages}"
        #render json: @quest.errors.full_messages, status: :unprocessable_entity
        redirect_to quest_url(quest_id), alert: @encounter.errors.full_messages
          #quest not saved   #refund_user?/salvage last response
      end
    else
        redirect_to quest_url(quest_id), notice: "insufficient bottle caps"
        #"insufficient funds"
    end
  end

  def show
    @encounter = Encounter.find_by(id: params[:id])
    render :show
  end

  private
  def encounter_params
    params.require(:encounter).permit(:name, :quest_id, :completion, :response_id, :type)
  end


  #this could go on a parent controller with the bottle cap check
  def create_response(prompt)
    #filters  the output of the Response create to load into a new quest
    response = Response.build_response(prompt, current_user.id)  #$$$ inside Response     
  end
end