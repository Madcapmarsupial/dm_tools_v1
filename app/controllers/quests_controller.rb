class QuestsController < ApplicationController

  def create
    @quest = Quest.new()

     if @quest.save 
      redirect_to @quest   #--> quest show
    else 
       render json: @quest.errors.full_messages, status: :unprocessable_entity
    end
  end

def show 
  @quest = Quest.find_by(id: params[:id])
  render :show
end 


   def show_start
      #timer
      #goal
      #henchman
      #place
      #consequences
   end

   def show_middle
    #villan and subfields
    #plotwists

   end

   def show_end
    #consequences
    #goal
    #timer 
   end

   def quest_overview
    @quest = Quest.find_by(id: params[:quest_id]) 
    #should list the created fields so far and hold a link
    render :overview
   end

  #  def add_note
  #  end

  # add connection



  #fetch timer, villain, goal, setting,
  #fetch start_fields
  #fetxh middle_fields
  #fetch end_fields
  #overview action

  #quest ->setting -> villain -> goal(check setting/villain) -> 

  # def quest_params
  #   params.require(:quest)
  # end

  private 
  def inner_setting_params
    params.require(:trait).permit(:value)
  end
  

end
