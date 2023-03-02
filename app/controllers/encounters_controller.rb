class EncountersController < ApplicationController
  before_action :authenticate_user!
  
  def create
    fail
  end

  def show
    @encounter = Encounter.find_by(id: params[:id])
    render :show
  end

  private
  def encounter_params
    params.require(:encounter).permit(:name, :quest_id, :completion, :response_id)
  end
end


        modified:   .gitignore
        modified:   Gemfile.lock
        modified:   app/controllers/application_controller.rb
        modified:   app/controllers/encounters_controller.rb
        modified:   app/controllers/quests_controller.rb
        modified:   app/models/encounter.rb
        modified:   app/models/field.rb
        modified:   app/models/quest.rb
        modified:   app/models/user.rb
        modified:   app/views/home/logged_in.html.erb
        modified:   app/views/quests/index.html.erb
        modified:   app/views/quests/show.html.erb
        modified:   config/application.rb
        modified:   config/environments/production.rb
        modified:   config/initializers/filter_parameter_logging.rb
        modified:   db/schema.rb
        modified:   db/seeds.rb
        deleted:    app/views/traits/.DS_Store
        deleted:    app/views/traits/edit.html.erb
        deleted:    app/views/traits/new.html.erb
        deleted:    app/views/traits/show.html.erb
        deleted:    app/views/fields/new.html.erb
        deleted:    app/views/fields/show.html.erb
        deleted:    app/models/quest_response.rb
        deleted:    app/models/setting.rb
        deleted:    app/models/trait.rb
        deleted:    app/models/objective.rb
        deleted:    app/models/plot_twist.rb
        deleted:    app/models/custom.rb
        deleted:    app/models/encounter_response.rb



