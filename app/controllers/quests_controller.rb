class QuestsController < ApplicationController
  #traits queue ends at 'empty'     --> points to :label column
  #fields queue ends at 'Custom'   --> points sublcasses uses :type

  def new
    @quest = Quest.new
    render :new
  end

  def create
    @quest = Quest.new
     if @quest.save 
        #villain, setting and objective are present in quest_params
        new_quest_prompt = @quest.quest_prompt(quest_params)

        bot_response = create_quest_completion(new_quest_prompt) #-> options for model and token count
        #bot_response['choices'][0]['text']
        #scenario_text = JSON.parse(QuestResponse.last.response_text)['choices'][0]['text']
        #JSON.parse(scenario_text)
        QuestResponse.create(prompt: new_quest_prompt, response_text: bot_response, quest_id: @quest.id)
        @quest.update(staged_response: bot_response["choices"][0]["text"])
      redirect_to @quest   #--> quest show
    else 
       render json: @quest.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show 
    @quest = Quest.find_by(id: params[:id])
    #@fields = @quest.fields
    @response = @quest.response
    #@response
    
      # response.get_element wont query but simply index into the loaded 'context'
    render :show
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
     params.require(:quest).permit(:villain, :setting, :objective, :staged_response) #staged_response
  end

  #need to set default max tokens
  #context options
  def create_quest_completion(user_prompt)
    myBot = OpenAI::Client.new
    response = myBot.completions(parameters: { model: "text-davinci-003", prompt: user_prompt, max_tokens: 2000})
  end


  # 
  # def inner_setting_params
  #   params.require(:trait).permit(:value)
  # end

end


#"{\"id\":\"cmpl-6ljWsoi4QuswxInUS1NTJaRQQ7aOY\",\"object\":\"text_completion\",\"created\":1676834450,\"model\":\"text-davinci-003\",\"choices\":[{\"text\":\"\\n\\n\\n{\\n    Scenario_name: ‘The Parlor Murderer’\\n    Description: 'The Player Characters arrive to a small parlor to investigate a murder. The owner of the parlor – a barber – is the alleged murderer.'\\n    Encounter_list: [\\n        {\\n            Encounter_1: ‘The Player Characters are welcomed to the barber shop by the barber, who proceeds to explain their reason for being there.’\\n        }, \\n        {\\n            Encounter_2: ‘The Player Characters proceed to interview witnesses and gather evidence, to gain a better understanding of the situation.’\\n        },\\n        {\\n            Encounter_3: ‘The Player Characters search the barber shop for any further clues, and stumble upon a secret passageway leading to the chambers of the barber.’\\n        },\\n        {\\n            Encounter_4: ‘The Player Characters confront the barber, who admittingly reveals itself as the murderer.’\\n        }\\n    ],\\n    Villain: ‘Barber’,\\n    Setting: ‘Parlor’,\\n    Objective: ‘To find the murderer’,\\n    Timer: ‘1 hour’,\\n    PlotTwist: ‘The barber is an alter-ego of one of the Player Characters, and they must battle themselves in order to reveal the truth.’  \\n}\",\"index\":0,\"logprobs\":null,\"finish_reason\":\"stop\"}],\"usage\":{\"prompt_tokens\":105,\"completion_tokens\":311,\"total_tokens\":416}}"], ["prompt", "create a dnd scenario with a barber as the villain, the setting is a parlor and the objective is a find the murderer and limit the scenario to 4 encounters. your response should be in JSON format with 8 paramaters ‘Scenario_name’, ’Description’, ‘Encounter_list’, ’Villain’, ’Setting’, ’Objective’, ‘Timer’, and ‘PlotTwist’ "], ["created_at", "2023-02-19 19:22:37.318731"], ["updated_at", "2023-02-19 19:22:37.318731"]]


#raw_output =  {"id"=>"cmpl-6m3CQalbD8PRBiHf6uX6cCLeANJDO",
#  "object"=>"text_completion",
#  "created"=>1676910062,
#  "model"=>"text-davinci-003",
#  "choices"=>[{"text"=>"\n\n{\"value\": \"This is an example sentence.\", \"length\": 21}", "index"=>0, "logprobs"=>nil, "finish_reason"=>"stop"}],
#  "usage"=>{"prompt_tokens"=>22, "completion_tokens"=>17, "total_tokens"=>39}}