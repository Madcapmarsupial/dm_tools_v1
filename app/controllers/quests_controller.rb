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

  def create
    @quest = Quest.new(user_id: current_user.id)
    begin
      if @quest.save
        Setting.create(name: quest_params["setting"], quest_id: @quest.id)
        Objective.create(name: quest_params["objective"], quest_id: @quest.id)
        Villain.create(name: quest_params["villain"], quest_id: @quest.id)
            # stting objective villain could be full hashes representing required fields

        redirect_to @quest 
      else
        @quest.errors.add :response, invalid_response: "#{response.errors.full_messages}"
        redirect_to root_path, alert: @quest.errors.full_messages
      end
    rescue StandardError => e
      redirect_to root_path, alert: e
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

  def update
    @quest = Quest.find_by(id: params[:id])
    if @quest.update(quest_params)
      redirect_to @quest
    else
      redirect_to root_path, alert: @quest.errors.full_messages
    end
  end

  def update_scene_list
     #update the completion with a new scene name
    @quest = Quest.find_by(id: params[:quest][:id])
    new_scene_name = (params[:quest][:scene_name])

    @quest.add_scene(new_scene_name)

    if @quest.save
      redirect_to @quest
    else
      redirect_to root_path, alert: @quest.errors.full_messages
    end
  end

  def generate
    @quest = Quest.find_by(id: params[:id])
    prompt_str = Quest.prompt(params)
    values = create_completion("quest", prompt_str)
      if @quest.update(values)    #values contains  -> (response_id, completion: name:)
        #QuestResponse.create(quest_id: @quest.id, response_id: values[:response_id])
          #if saved add entry into join table
        create_completion_scene_fields(@quest)
        redirect_to @quest   #--> quest show
      else
        @quest.errors.add :response, invalid_response: "#{@quest.errors.full_messages}"
        redirect_to @quest, alert: @quest.errors.full_messages
      end
  end


  private

  include Generatable
    # create_response. create_completion

  # def create_response(prompt)
  #   #filters  the output of the Response create to load into a new quest
  #   response = Response.build_response(prompt, current_user.id)  #$$$ inside Response      
  # end

  def create_completion_scene_fields(quest)
    quest.scene_list.count.times.each do |i|
      scene_name = scene_list[i]["title"]
      Scene.create(quest_id: quest.id, name: scene_name)
    end
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


