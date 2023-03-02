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