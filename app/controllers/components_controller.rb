class ComponentsController < ApplicationController


  # components list may depend upon feild type
  COMPONENTS = { 
    "reward" => Proc.new {Reward},
    "creature" => Proc.new {Creature},
    "active_effect" => Proc.new {ActiveEffect},
    "special_mechanic" => Proc.new {SpecialMechanic}

    #"area_layout" => Proc.new
    #"location_description" = Proc.new

    #"custom_component" => Proc.new {},
  }

  def create
    begin
      #test
        #this is list_item specific will need to be tweaked
        #this can be done on the model
        field = Field.find_by(id: params[:component][:field_id])
        model_type = COMPONENTS[list_component_params[:type]].call
        alignment = list_component_params[:alignment]
        prompt = model_type.prompt(list_component_params)


          response = create_response(prompt)
          values = {response_id: response.id, completion: response.text_to_hash, field_id: params[:component][:field_id], alignment: alignment}
          new_component = model_type.new(values)

          # if save
          new_component.save!
      
          # this will need to be genralized to feild.
        redirect_to encounter_url(field)
    rescue StandardError => e
      redirect_to encounter_url(field), alert: e
    end
  end
  

  private
   def list_component_params
    params.require(:component).permit(:name, :description, :alignment, :type, :field_id)
   end
  #single_component_params

  def create_response(prompt)
    response = Response.build_response(prompt, current_user.id)  #$$$ inside Response     
  end


end