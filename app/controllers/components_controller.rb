class ComponentsController < ApplicationController


  COMPONENTS = { 
    "reward" => Proc.new {},
    "creature" => Proc.new {Creature},
    "active_effect" => Proc.new {},
    "special_mechanic" => Proc.new {}

    #"area_layout" => Proc.new
    #"location_description" = Proc.new

    #"custom_component" => Proc.new {},
  }

  def create


      #this is list_item specific will need to be tweaked

      #this can be done on the model
     
      model_type = COMPONENTS[list_component_params[:type]].call
      
      alignment = list_component_params[:alignment]
      prompt = model_type.prompt(list_component_params)


      response = create_response(prompt)
      #alignment is left out
      values = {response_id: response.id, completion: response.text_to_hash, field_id: params[:component][:field_id], alignment: alignment}

      new_component = model_type.new(values)
      new_component.save!


      redirect_to encounters_url(params[:component][:field_id]), notice: "that function isn't built yet"
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



        modified:   app/controllers/encounters_controller.rb
        modified:   app/models/encounter.rb
        modified:   app/views/encounters/show.html.erb
        modified:   config/routes.rb
        modified:   db/schema.rb
                    app/controllers/components_controller.rb
                    app/models/component.rb
                    app/models/creature.rb
                    app/views/components/