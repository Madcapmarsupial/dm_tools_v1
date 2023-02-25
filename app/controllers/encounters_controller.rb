class EncountersController < ApplicationController
  def create
    @encounter = Encounter.new(encounter_params) #quest_id: params[:encounter][:quest_id], name: params[:encounter][:name])
    @quest = @encounter.quest
   
    if @encounter.save
         @encounter.create_completion_and_response    #(prompt, token_limit)
      #we now have a response filled out with a completion and context
      
      #if check for Response and completion errors passes
         redirect_to @encounter   #--> show
      #else
          #something is wrong with the completion/response situation
      #end
    else
       redirect_to @quest 
    end
  end

  def show
    @encounter = Encounter.find_by(id: params[:id])
    render :show
  end

  private
  def encounter_params
    params.require(:encounter).permit(:name, :quest_id)
  end

end