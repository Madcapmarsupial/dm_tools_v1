module Generatable
  extend ActiveSupport::Concern



  included do
      # any code that you want inside your class
    def create_response(prompt)
      #filters  the output of the Response create to load into a new quest
      response = Response.build_response(prompt, current_user.id)  #$$$ inside Response     
    end

    

    def create_completion(type, prompt_str)
      #@model = model_class.find_by(id: model_id)
      begin
        if current_user.has_enough_bottlecaps? 
          response = create_response(prompt_str)  #(Quest, @quest.id, prompt_str)
          #validations  built into create_response    
          values = { response_id: response.id, completion: response.text_to_hash, name: response.text_to_hash["#{type}_name"]}
          values
        else
            redirect_to root_path, notice: "insufficient coins"
        end
      rescue StandardError => e
        #refund -> and render :new #redirect_to user_home  #render response.errors.full_messaged too?
        redirect_to root_path, alert: e
      end
    end

  end

  class_methods do
    # define class methods here
   
  end
end