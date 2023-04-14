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
    q_name = params[:quest][:completion][:quest_name].titleize
    @quest = Quest.new(user_id: current_user.id, completion: params[:quest][:completion], name: q_name) #Quest.blank_completion
    #@quest.blank_completion

    begin
      if @quest.save
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
      # prompt grabs the contexts from the rereq_fields 
        #we need to filter out any nil or "" values


    values = create_completion("quest", prompt_str)
      if @quest.update(values)    #values contains  -> (response_id, completion: name:)
        #QuestResponse.create(quest_id: @quest.id, response_id: values[:response_id])
          #if saved add entry into join table
        create_completion_scenes(@quest)
        redirect_to @quest   #--> quest show
      else
        @quest.errors.add :response, invalid_response: "#{@quest.errors.full_messages}"
        redirect_to @quest, alert: @quest.errors.full_messages
      end
  end

   


  private

  include Generatable

   def create_completion_scenes(quest)
    quest.sequence_of_events.each do |event|

      scene_name = event["title"]
      summary = event["description"]
      steps =  event["narrative_connection_to_next_event"]
      mini_completion = {"scene_name" => scene_name, "summary" => summary, "next_steps_for_players" => steps }
      
      #scene_name = quest.sequence_of_events[i]["title"]
      #summary = (quest.sequence_of_events[i]["description"] + quest.sequence_of_events[i]["narrative_connection_to_next_event"])
      Scene.create(quest_id: quest.id, name: scene_name, completion: mini_completion)
    end
  end


  def quest_params  #only really prompt params right now
     params.require(:quest).permit(:villain, :setting, :objective, :completion, :new_completion, :response_id, :user_id, :name)
  end
end


