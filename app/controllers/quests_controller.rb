class QuestsController < ApplicationController
  # if you redirect to a URL, check it with a permitted list (strong params) or a regular expression.

  def index
      @quests = current_user.quests
      render :index
  end

  def new
      @quest = Quest.new(user_id: current_user.id)
      render :new
  end

  def update
    @quest = Quest.find_by(id: params[:id])

    if @quest.update(quest_params)
      redirect_to @quest
    else
      redirect_to root_path, alert: @quest.errors.full_messages
    end
  end

  def create
    begin
      if current_user.has_enough_bottlecaps?  #check user balance ->  5 ish generations

        # l_prompt = Location.blank_prompt(location_params)
        # response = create_response(l_prompt)  #user charged --> calls Response.create
        # l_values = {response_id: response.id, completion: response.text_to_hash}
        # location = Location.create(l_values)


        # o_prompt = Objective.blank_prompt(objective_params(location.completion, params))
        # response = create_response(o_prompt)
        # o_values = {response_id: response.id, completion: response.text_to_hash}
        # objective = Objective.create(o_values)

        # v_prompt = Villain.blank_prompt(villain_params(objective.completion, location.completion, params[:quest][:villain]))
        # response = create_response(v_prompt)
        # v_values = {response_id: response.id, completion: response.text_to_hash}
        # villain = Villain.create(v_values)
        
      user_values =  {"setting"=> quest_params["setting"], "objective"=>quest_params["objective"], "villain"=> quest_params["villain"]}
      @quest = Quest.new(user_id: current_user.id, completion: user_values)
        #create setting
        #create objective
          #create villain
            #create completion

        #options = {"setting_completion"=> location.completion, "villain_completion" => villain.completion, "objective_completion"=> objective.completion}
        # prompt = Quest.prompt(options)  #import other prompts
        # response = create_response(prompt)  #user charged --> calls Response.create
        # values = {response_id: response.id, completion: response.text_to_hash, user_id: current_user.id}
        # @quest = Quest.new(values)
        # @quest.name = @quest.scenario_name
        if @quest.save
        

          redirect_to @quest   #--> quest show
        else
          #refund -> and render :new #redirect_to user_home  #render response.errors.full_messaged too?
          @quest.errors.add :response, invalid_response: "#{response.errors.full_messages}"
          #render json: @quest.errors.full_messages, status: :unprocessable_entity
          redirect_to root_path, alert: @quest.errors.full_messages
            #quest not saved   #refund_user?/salvage last response
        end
      else
          redirect_to root_path, notice: "insufficient bottle caps"
          #"insufficient funds"
      end
    rescue StandardError => e
      redirect_to new_quest_path, alert: e
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
      redirect_to root_path, notice: "You must sign in to continue"
    end
  end

  def update_encounter_list
     #update the completion with a new encounter name
    @quest = Quest.find_by(id: params[:quest][:id])
    new_encounter_name = (params[:quest][:encounter_name])

    @quest.add_encounter(new_encounter_name)

    if @quest.save
      redirect_to @quest
    else
      redirect_to root_path, alert: @quest.errors.full_messages
    end
  end

  def generate
    @quest = Quest.find_by(id: params[:id])
    begin
      if current_user.has_enough_bottlecaps? 
        response = create_response(Quest.prompt(@quest.id))

        values = {response_id: response.id, completion: response.text_to_hash, name: response.text_to_hash["scenario_name"]}
        if @quest.update(values)
          redirect_to @quest   #--> quest show
        else
          #refund -> and render :new #redirect_to user_home  #render response.errors.full_messaged too?
          @quest.errors.add :response, invalid_response: "#{response.errors.full_messages}"
          #render json: @quest.errors.full_messages, status: :unprocessable_entity
          redirect_to @quest, alert: @quest.errors.full_messages
            #quest not saved   #refund_user?/salvage last response
        end
      else
          redirect_to root_path, notice: "insufficient coins"
          #"insufficient funds"
      end
   rescue StandardError => e
      redirect_to root_path, alert: e
    end
  end




  private
  def create_response(prompt)
    #filters  the output of the Response create to load into a new quest
    response = Response.build_response(prompt, current_user.id)  #$$$ inside Response     
  end

  def quest_params  #only really prompt params right now
     params.require(:quest).permit(:villain, :setting, :objective, :completion, :new_completion, :response_id, :user_id, :name)
  end

  def location_params
     params.require(:quest).permit(:villain, :setting, :objective)
  end

  def objective_params(l_completion, params)
     q = params[:quest]
     {"villain" => q[:villain], "objective" => q[:objective], "setting_completion" => l_completion}
  end

  def villain_params(o_completion, l_completion, villain)
     {"villain" => villain, "objective_completion" => o_completion, "setting_completion" => l_completion}
  end
end


