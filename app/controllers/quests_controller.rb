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
    values_hash = new_quest_with_response #-> --> check funds -> generate complition -> create -> response -> charge Response $$$
    @quest = Quest.new(values_hash)
    if @quest.save
      #if we reach this point the validations have all passed
      redirect_to @quest   #--> quest show
    else
      #refund -> and render :new #redirect_to user_home  #render response.errors.full_messaged too?
      render json: @quest.errors.full_messages, status: :unprocessable_entity
      fail
        #quest not saved
        #user charged    #refund_user?/salvage last response
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
  def new_quest_with_response
    #tweak this to be on Response side
    response = Response.create_response(Quest.quest_prompt(quest_params), current_user.id)  #$$$ inside Response
    v_hash = {response_id: response.id, completion: response.text_to_hash, user_id: current_user.id}
  end

  def encounter_names
    params.require(:encounter).permit(:old_encounter_name, :new_encounter_name)
  end

  def quest_params  #only really prompt params right now
     params.require(:quest).permit(:villain, :setting, :objective, :completion, :response_id, :user_id, :name)
  end
end


