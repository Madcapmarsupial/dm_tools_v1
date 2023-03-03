class QuestsController < ApplicationController
  # if you redirect to a URL, check it with a permitted list (strong params) or a regular expression.
  before_action :authenticate_user!

  def index
      @quests = current_user.quests
      render :index
  end

  def new
      @quest = Quest.new(user_id: current_user.id)
      render :new
  end

  def create
    prompt = Quest.prompt(quest_params)
    response = create_response(prompt) 
    values = {response_id: response.id, completion: response.text_to_hash, user_id: current_user.id}
      # --> calls Response.create
    @quest = Quest.new(values)
    if @quest.save
      #if we reach this point the validations have all passed
      redirect_to @quest   #--> quest show
    else
      #refund -> and render :new #redirect_to user_home  #render response.errors.full_messaged too?
      @quest.errors.add :response, invalid_response: "#{response.errors.full_messages}"
      render json: @quest.errors.full_messages, status: :unprocessable_entity
    fail
        #quest not saved
        #user not charged    #refund_user?/salvage last response
    end
  end

  def show
    if user_signed_in?
      @quest =  current_user.quests.find_by(id: params[:id])
      if @quest
        @response = @quest.completion
        render :show
      else
        redirect_back(fallback_location: root_path)
      end
    else
      redirect_to root_path
    end
  end




  private
  def create_response(prompt)
    #filters  the output of the Response create to load into a new quest
    response = Response.build_response(prompt, current_user.id)  #$$$ inside Response
    #if response.save
      #return values
    #  return response
     # {response_id: response.id, completion: response.text_to_hash, user_id: current_user.id}
    #else
      #add error to quest.errors      
  end

  def encounter_names
    params.require(:encounter).permit(:old_encounter_name, :new_encounter_name)
  end

  def quest_params  #only really prompt params right now
     params.require(:quest).permit(:villain, :setting, :objective, :completion, :response_id, :user_id, :name)
  end
end


