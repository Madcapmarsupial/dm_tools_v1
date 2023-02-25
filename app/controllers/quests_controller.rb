class QuestsController < ApplicationController
  #traits queue ends at 'empty'     --> points to :label column
  #fields queue ends at 'Custom'   --> points sublcasses uses :type

  def new
    #user_id here
    @quest = Quest.new(user_id: current_user.id) #params[:user_id])
    render :new
  end

  def index
    #@user need access user
    user =  User.find_by(id: current_user.id)#arams[:user][:id])
    if user
      @quests = user.quests
      render :index
    else
      redirect_back(fallback_location: root_path)
    end
  end




  def create
    @quest = Quest.new(user_id: params[:quest][:user_id])
     if @quest.save 
        #villain, setting and objective are present in quest_params
        new_quest_prompt = @quest.quest_prompt(quest_params)

        bot_response = @quest.create_quest_completion(new_quest_prompt) 
        QuestResponse.create(prompt: new_quest_prompt, response_text: bot_response, quest_id: @quest.id)
        @quest.update(staged_response: bot_response["choices"][0]["text"])

        redirect_to @quest   #--> quest show
    else
        #render :new
        #redirect_to user_home
       render json: @quest.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show 
    @quest = Quest.find_by(id: params[:id])
    if @quest
      @response = @quest.response    
      render :show
    else
      redirect_back(fallback_location: root_path)
    end
  end 

  #encounters are nested thus we have a specific route for it
  def update_encounter_name #'encounter_list'
    
    @quest = Quest.find_by(id: params[:id])
    new_name = params["encounter"]["new_encounter_name"] 
    old_name = params["encounter"]["old_encounter_name"]

    #update the staged response
    edited_response = @quest.edit_encounter_name(new_name, old_name)
    @quest.update(staged_response: edited_response) #quest_params
    
    #create a new QuestResponse with the staged_response as the choices[o]text
    #but no new completion
    old_response = @quest.response
    old_response.create_new_quest_response_from_staged
      #creates a new questResponse to update context and provide some history
      
    redirect_to @quest
  end

  private 
  def encounter_names
    params.require(:encounter).permit(:old_encounter_name, :new_encounter_name)
  end

  def quest_params
     params.require(:quest).permit(:villain, :setting, :objective, :staged_response, :user_id)
  end
end


