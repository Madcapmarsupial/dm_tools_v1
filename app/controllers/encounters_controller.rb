class EncountersController < ApplicationController
  def create
    @encounter = Encounter.new(quest_id: params[:quest_id], name: params[:encounter]['target_encounter'])
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
       redirect_to @quest #render json: #@encounter.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    @encounter = Encounter.find_by(id: params[:id])
    render :show
  end

end