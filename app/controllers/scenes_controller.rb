class ScenesController < ApplicationController
  #models have :name completions have "type_name"
  # def create
  #   quest_id = params[:scene][:quest_id]
  #   #params[:field][:type]
  #   #quest_id = params[:field][:quest_id]


  #   begin
  #     if current_user.has_enough_bottlecaps?  #check user balance
  #       scene_name = params[:scene][:name]
  #       e_prompt = scene.prompt(quest_id, scene_name)
  #       #name passed via params in view

  #       response = create_response(e_prompt)  #user charged --> calls Response.create
  #       #possibility that the response is (new) and invalid

  #       values = {response_id: response.id, completion: response.text_to_hash, quest_id: quest_id, name: scene_name} #
  #       @scene = scene.new(values)


  #       if @scene.save
  #         #if we reach this point the validations have all passed
  #         redirect_to @scene   #--> quest show
  #       else
  #         #refund -> and render :new #redirect_to user_home  #render response.errors.full_messaged too?
  #         @scene.errors.add :response, invalid_response: "#{response.errors.full_messages}"
  #         #render json: @quest.errors.full_messages, status: :unprocessable_entity
  #         redirect_to quest_url(quest_id), alert: @scene.errors.full_messages
  #           #quest not saved   #refund_user?/salvage last response
  #       end
  #     else
  #         redirect_to quest_url(quest_id), notice: "insufficient bottle caps"
  #         #"insufficient funds"
  #     end
  #   rescue StandardError => e
  #     redirect_to quest_url(quest_id), alert: e
  #   end
  # end

  def show
    @scene = Scene.find_by(id: params[:id])
    render :show
  end

  def update
    @scene = Scene.find_by(id: params[:id])
    #what type of update?
    #update completion
      #control flow to decide what type of update params to call
     new_completion = @scene.add_component(component_params)
        #component = {name = val, description = val}
    #save might be better
    #add validations
    if @scene.update(completion: new_completion)
      redirect_to @scene
    else
      redirect_to @scene, alert: @scene.errors.full_messages
    end
  end







  private
  def scene_params
    params.require(:scene).permit(:name, :quest_id, :completion, :response_id, :type)
  end

  def component_params
   params.require(:component).permit(:type, :description, :name)
  end
  #this could go on a parent controller with the bottle cap check
  #include Generatable

  # def create_response(prompt)
  #   #filters  the output of the Response create to load into a new quest
  #   response = Response.build_response(prompt, current_user.id)  #$$$ inside Response      
  # end

end